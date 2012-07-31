## -*- tcl -*-
# # ## ### ##### ######## ############# #####################

## ATTENTION. This file contains '# line' directives for embedded C
## code, with hardwired line numbers. Please check and edit these
## directives for correctness after editing this file.

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we define the processing of callbacks going from the raw
## OpenNI call to associated Tcl handler command.

# # ## ### ##### ######## ############# #####################

proc kt_cb_cname {name} {
    #puts |$name|
    regsub -all -- {[^a-zA-Z0-9_]} $name {[scan {\0} %c]} cname
    #puts |$cname|
    set cname [subst $cname]
    #puts |$cname|
    return [string totitle $cname]
}

proc kt_cb_handler {group name cname signature body {mode all}} {
    set esignature [list {XnNodeHandle h} {*}$signature]
    set fsignature [list {XnNodeHandle h} {*}$signature {void* clientData}]

    foreach parameter $esignature {
	set ptype     [join [lrange $parameter 0 end-1] { }]
	set pvariable [lindex $parameter end]

	if {[string match {*XnChar\*} $ptype]} {
	    # String pointer. Event gets a dynamically allocated copy.
	    lappend eencode     "[critcl::at::here!]e->$pvariable = kinetcl_strdup ($pvariable);"
	    lappend edecode     "[critcl::at::here!]$pvariable = e->$pvariable;"
	    lappend evardef     "[critcl::at::here!]$parameter;"
	    lappend edestructor "[critcl::at::here!]ckfree (e->$pvariable);"
	} elseif {[string match {*\*} $ptype]} {
	    # Any pointer. Event gets a structural copy.
	    lappend eencode "[critcl::at::here!]e->$pvariable = *$pvariable;"
	    lappend edecode "[critcl::at::here!]$pvariable = &e->$pvariable;"
	    lappend evardef "[critcl::at::here!]$parameter;"
	    set ptype [string range $ptype 0 end-1]
	} else {
	    # Regular variable. Event has a plain copy.
	    lappend eencode  "[critcl::at::here!]e->$pvariable = $pvariable;"
	    lappend edecode  "[critcl::at::here!]$pvariable = e->$pvariable;"
	    lappend evardef  "[critcl::at::here!]$parameter;"
	}
	set ptype [string map {{const } {}} $ptype]
	lappend estructd "[critcl::at::here!]$ptype $pvariable;"
    }
    #lappend edestructor {ckfree ((char*) e);}
    lappend edestructor "[critcl::at::here!]/* Destruction of the main event structure is handled by the caller */"

    set evardef     [join $evardef     "\n\t\t"]
    set esignature  [join $estructd    "\n\t\t"]
    set edestructor [join $edestructor "\n\t\t"]
    set eencode     [join $eencode \n\t\t]
    set edecode     [join $edecode \n\t\t]
    set fsignature  [join $fsignature {, }]

    lappend map @@group@@       $group
    lappend map @@cname@@       $cname
    lappend map @@name@@        $name
    lappend map @@signature@@   $fsignature
    lappend map @@body@@        $body
    lappend map @@esignature@@  $esignature
    lappend map @@evardef@@     $evardef
    lappend map @@edestructor@@ $edestructor
    lappend map @@eencode@@     $eencode
    lappend map @@edecode@@     $edecode

    if {$mode ne "all"} {
	lappend map @@eeqguard@@ [critcl::at::here!][string map $map {if (@stem@_callback_@@cname@@_queued (instance)) return;}]
	lappend map @@edqguard@@ [critcl::at::here!][string map $map {@stem@_callback_@@cname@@_dequeue (instance);}]
    } else {
	lappend map @@eeqguard@@ ""
	lappend map @@edqguard@@ ""
    }

    kt_cb_common_core

    # # ## ### ##### ######## ############# #####################
    ## Event deletion on destruction is handled by the higher-level _unset functions.
    ## They call <<Tcl_DeleteEvents (@stem@_callback_@@cname@@_delete, (ClientData) instance);>>

    # # ## ### ##### ######## ############# #####################
    insvariable Tcl_Obj* command$cname "
	Command prefix for '$name' events ($group aspect)
    " [string map $map {
	instance->command@@cname@@ = NULL;
    }]

    if {$mode ne "all"} {
	kt_cb_queue_management $name $cname
    }

    kt_cb_event_types $map
    kt_cb_event_tcl   $map
    kt_cb_event_oni   $map

    # # ## ### ##### ######## ############# #####################
    return
}

# # ## ### ##### ######## ############# #####################
## This code is fully run only once. At the second time the
## duplicate field will error out, and the catch simply lets
## us proceed, knowing, implicitly, that the fields and mgmt are
## present.

proc kt_cb_common_core {} {
    catch {
	insvariable Tcl_Interp* interp {
	    Interpreter for all callback handlers
	} {
	    instance->interp = interp;
	} {
	    /* instance->interp is a non-owned copy, nothing to release */
	}

	insvariable Tcl_ThreadId owner  {
	    Thread owning the instance
	} {
	    instance->owner  = Tcl_GetCurrentThread ();
	} {
	    /* instance->owner is a plain id, nothing to release. */
	}
    }
    return
}

# # ## ### ##### ######## ############# #####################

proc kt_cb_queue_management {name cname} {
    lappend map @@name@@  $name
    lappend map @@cname@@ $cname

    insvariable int queued$cname "
	    Flag, true when at least one '$name' event is queued.
	" [string map $map {
	    /* Initialize the queue flag for collapsed '@@name@@' events.*/
	    instance->queued@@cname@@ = 0;
	}]
    
    insvariable Tcl_Mutex mutex$cname "
	    Mutex controlling access to the '$name'-flag.
	" [string map $map {
	    /* Initialize the mutex for collapsed '@@name@@' events.*/
	    instance->mutex@@cname@@  = 0;
	}] [string map $map {
	    /* Destroy mutex with instance */
	    Tcl_MutexFinalize (&instance->mutex@@cname@@);
	}]

    support [string map $map {
	static int
	@stem@_callback_@@cname@@_queued (@instancetype@ instance) {
	    int queued;
	    Tcl_MutexLock (&instance->mutex@@cname@@);
	    queued = instance->queued@@cname@@;
	    if (!queued) {
		instance->queued@@cname@@ = 1;
	    }
	    Tcl_MutexUnlock (&instance->mutex@@cname@@);
	    return queued;
	}

	static void
	@stem@_callback_@@cname@@_dequeue (@instancetype@ instance) {
	    Tcl_MutexLock (&instance->mutex@@cname@@);
	    instance->queued@@cname@@ = 0;
	    Tcl_MutexUnlock (&instance->mutex@@cname@@);
	}
    }]

    return
}

# # ## ### ##### ######## ############# #####################

proc kt_cb_event_types {map} {
    # Find a way to computationally specify the embedded line directives below.

    support [string map $map {
	/* Tcl Event Structure for '@@name@@'.
	 * The 'clientData
	 */
	typedef struct @stem@_callback_@@cname@@_EVENT {
	    Kinetcl_Event event;
	    @instancetype@ instance;
	    /* ----------------------------------------------------------------- */
	    @@esignature@@
# line 199 "support_cbhandlers.tcl"
	    /* ----------------------------------------------------------------- */
	} @stem@_callback_@@cname@@_EVENT;
    }]
    return
}

# # ## ### ##### ######## ############# #####################
## Kinetcl callback handler. Invoked from the event queue of
## the owning thread. The events are set up by the raw
## handler, see the next function.

proc kt_cb_event_tcl {map} {
    support [string map $map {
	static int
	@stem@_callback_@@cname@@_tcl_handler (Tcl_Event* evPtr, int mask)
	{
	    @stem@_callback_@@cname@@_EVENT* e = (@stem@_callback_@@cname@@_EVENT*) evPtr;
	    @instancetype@ instance;
	    @@evardef@@
# line 219 "support_cbhandlers.tcl"
	    Tcl_Obj* cmd;
	    Tcl_Obj* details;
	    Tcl_Interp* interp;
	    /* ASSERT (h == instance->handle) ? */

	    /* we are treating kinetcl's callbacks like fileevents,
	     * not processing them when not allowed by the core.
	     */
	    if (!(mask & TCL_FILE_EVENTS)) { return 0; }
	    instance = e->instance;
	    @@edqguard@@
# line 231 "support_cbhandlers.tcl"
	    /* Drop event '@@name@@' if no handler set. But also
	    * signal it as processed to get rid of it in the
	    * queue too. Note: This should not be necessary,
	    * given that the higher _unset functions drop all
	    * unprocessed events from the queue.
	    */
	    if (!instance->command@@cname@@) {
		@@edestructor@@
# line 240 "support_cbhandlers.tcl"
		return 1;
	    }

	    /* Decode event structure into local variables. */
	    @@edecode@@
# line 246 "support_cbhandlers.tcl"
	    interp = instance->interp;

	    details = Tcl_NewDictObj ();
	    {
	      @@body@@ }
# line 252 "support_cbhandlers.tcl"
	    @@edestructor@@
# line 254 "support_cbhandlers.tcl"
	    cmd = Tcl_DuplicateObj (instance->command@@cname@@);
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@name@@", -1));
	    Tcl_ListObjAppendElement (interp, cmd, instance->self);
	    Tcl_ListObjAppendElement (interp, cmd, details);

	    /* Invoke "{*}$cmdprefix $self @@name@@ ..." */
	    kinetcl_invoke_callback (interp, cmd);

	    /* Signal to caller that the event has been processed */
	    return 1;
	}
    }]
    return
}

# # ## ### ##### ######## ############# #####################
## (1) Callback handler function invoked by OpenNI. It does
## nothing more than setting up and enqueueing the call as
## event to be processed later.
#
## (2) Handler invoked by Tcl_DeleteEvents (see instance destructor)
## Filters out Kinetcl events of the instance and marks them for destruction.
## nothing more than setting up and enqueueing the call as
## event to be processed later.

proc kt_cb_event_oni {map} {
    support [string map $map {
	static void
	@stem@_callback_@@cname@@_free (Kinetcl_Event* evPtr)
	{
	    @stem@_callback_@@cname@@_EVENT* e = (@stem@_callback_@@cname@@_EVENT*) evPtr;
	    
	    /* Destroy this event, here we deal with the internal allocated parts */
	    @@edestructor@@
# line 289 "support_cbhandlers.tcl"
	}

	static void
	@stem@_callback_@@cname@@_handler (@@signature@@)
	{
	    @instancetype@ instance = (@instancetype@) clientData;
	    @stem@_callback_@@cname@@_EVENT* e;

	    @@eeqguard@@
# line 299 "support_cbhandlers.tcl"
	    e = (@stem@_callback_@@cname@@_EVENT*) ckalloc (sizeof (@stem@_callback_@@cname@@_EVENT));
	    e->event.event.proc = @stem@_callback_@@cname@@_tcl_handler;
	    e->event.delproc    = @stem@_callback_@@cname@@_free;
	    e->instance = instance;
	    @@eencode@@
# line 305 "support_cbhandlers.tcl"
	    if (kinetcl_locked (instance->context, (Kinetcl_Event*) e)) return;

	    Tcl_ThreadQueueEvent(instance->owner, (Tcl_Event *) e, TCL_QUEUE_TAIL);
	    Tcl_ThreadAlert     (instance->owner);
	}

	static int
	@stem@_callback_@@cname@@_delete (Tcl_Event* evPtr, ClientData clientData)
	{
	    @instancetype@ instance = (@instancetype@) clientData;
	    @stem@_callback_@@cname@@_EVENT* e = (@stem@_callback_@@cname@@_EVENT*) evPtr;

	    /* Keep events not issued by Kinetcl */
	    if (e->event.event.proc != @stem@_callback_@@cname@@_tcl_handler) {
		return 0;
	    }
	    /* Keep events not issued by the instance about to be destroyed */
	    if (e->instance != instance) {
		return 0;
	    }

	    @@edqguard@@
# line 328 "support_cbhandlers.tcl"
	    @stem@_callback_@@cname@@_free ((Kinetcl_Event*) evPtr);
	    return 1;
	}
    }]

    return
}

# # ## ### ##### ######## ############# #####################

proc kt_cb_methods {callback name cname allnames cons dest {detail {}}} {
    # - callback:	Overall C name of the callback (group) /OpenNI
    # - name:		Tcl name of the individual callback (command) /Tcl
    # - cname:		C name of the individual callback (command) /Tcl
    #                   we generate functions for.
    # - allnames:	List of all commands in the group
    # - cons:           OpenNI registration function for the callback group
    # - dest:           OpenNI unregister function for the callback group
    # - detail:         Additional arguments for registration function.

    if {$detail ne {}} {
	set detail " \"$detail\","
    }

    # For callback group containing more than one callback we have to
    # generate additional guard code for construction and deletion of
    # the C callback handling the group.
    set first 1
    set anti  {}
    foreach c $allnames {
	lappend handlers "@stem@_callback_${c}_handler"
	if {$c eq $cname} continue
	if {$first} {
	    lappend anti "[critcl::at::here!]/* Keep C callback if other Tcl callbacks still active */"
	    set first 0
	}
	lappend anti "[critcl::at::here!]if (instance->command${c}) return;"
    }

    lappend map @@callback@@     $callback
    lappend map @@cname@@        $cname
    lappend map @@handlers@@     [join $handlers ,]
    lappend map @@antiguard@@    [join $anti "\n\t\t"]
    lappend map @@consfunction@@ $cons
    lappend map @@destfunction@@ $dest
    lappend map @@detail@@       $detail

    method set-callback-$name {cmdprefix} [string map $map {
	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "cmdprefix");
	    return TCL_ERROR;
	}

	return @stem@_callback_@@cname@@_set (instance, objv [2]);
    }]

    method unset-callback-$name {} [string map $map {
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	@stem@_callback_@@cname@@_unset (instance, 1);
	return TCL_OK;
    }]
   
    # The command@@...@@ variable(s) used below are defined by calls
    # of kt_cb_handler above.

    support [string map $map {
	static void
	@stem@_callback_@@cname@@_unset (@instancetype@ instance, int dev)
	{
	    /* Single callback handle for 2 callbacks */
	    if (!instance->callback@@callback@@) return;
	    if (!instance->command@@cname@@) return;

	    Tcl_DecrRefCount (instance->command@@cname@@);
	    instance->command@@cname@@ = NULL;

	    @@antiguard@@
# line 410 "support_cbhandlers.tcl"
	    @@destfunction@@ (instance->handle,@@detail@@ instance->callback@@callback@@);
	    instance->callback@@callback@@ = NULL;

	    if (!dev) return;
	    Tcl_DeleteEvents (@stem@_callback_@@cname@@_delete, (ClientData) instance);
	}

	static int
	@stem@_callback_@@cname@@_set (@instancetype@ instance, Tcl_Obj* cmdprefix)
	{
	    Tcl_Obj* cmd;

	    if (!instance->callback@@callback@@) {
		Tcl_Interp* interp = instance->interp;
		XnCallbackHandle callback;
		XnStatus s;

		s = @@consfunction@@ (instance->handle,@@detail@@
				      @@handlers@@,
				      instance,
				      &callback);
		CHECK_STATUS_RETURN;

		instance->callback@@callback@@ = callback;
	    }

	    @stem@_callback_@@cname@@_unset (instance, 0);
	    instance->command@@cname@@ = cmdprefix;
	    Tcl_IncrRefCount (cmdprefix);
	    return TCL_OK;
	}
    }]
    return
}

# # ## ### ##### ######## ############# #####################
return
