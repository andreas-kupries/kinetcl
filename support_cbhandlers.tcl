## -*- tcl -*-
# # ## ### ##### ######## ############# #####################

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we define the processing of callbacks going from the raw
## OpenNI call to associated Tcl handler command.

# # ## ### ##### ######## ############# #####################

proc kt_cbhandler {group name cname signature body {mode all}} {
    set esignature [list {XnNodeHandle h} {*}$signature]
    set fsignature [list {XnNodeHandle h} {*}$signature {void* clientData}]

    foreach parameter $esignature {
	set ptype     [join [lrange $parameter 0 end-1] { }]
	set pvariable [lindex $parameter end]

	if {[string match {*XnChar\*} $ptype]} {
	    # String pointer. Event gets a dynamically allocated copy.
	    lappend eencode     "e->$pvariable = kinetcl_strdup ($pvariable);"
	    lappend edecode     "$pvariable = e->$pvariable;"
	    lappend evardef     "$parameter;"
	    lappend edestructor "ckfree (e->$pvariable);"
	} elseif {[string match {*\*} $ptype]} {
	    # Any pointer. Event gets a structural copy.
	    lappend eencode "e->$pvariable = *$pvariable;"
	    lappend edecode "$pvariable = &e->$pvariable;"
	    lappend evardef "$parameter;"
	    set ptype [string range $ptype 0 end-1]
	} else {
	    # Regular variable. Event has a plain copy.
	    lappend eencode  "e->$pvariable = $pvariable;"
	    lappend edecode  "$pvariable = e->$pvariable;"
	    lappend evardef  "$parameter;"
	}
	set ptype [string map {{const } {}} $ptype]
	lappend estructd "$ptype $pvariable;"
    }
    #lappend edestructor {ckfree ((char*) e);}
    lappend edestructor {/* Destruction of the main event structure is handled by the caller */}

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
	lappend map @@eeqguard@@ "[string map $map {if (@stem@_callback_@@cname@@_queued (instance)) return;}]"
	lappend map @@edqguard@@ [string map $map {@stem@_callback_@@cname@@_dequeue (instance);}]
    } else {
	lappend map @@eeqguard@@ ""
	lappend map @@edqguard@@ ""
    }

    uplevel 1 [string map $map {
	# # ## ### ##### ######## ############# #####################
	## This code is fully run only once. At the second time the
	## duplicate field will error out, and the catch simply lets
	## us proceed, knowing, implicitly, that we field and mgmt is
	## present.
	catch {
	    field Tcl_Interp*  interp {Interpreter for all callback handlers}
	    field Tcl_ThreadId owner  {Thread owning the instance}

	    constructor {
		instance->interp = interp;
		instance->owner  = Tcl_GetCurrentThread ();
	    }
	    destructor {
		/* instance->interp is a non-owned copy, nothing to do */
		/* instance->owner  is a plain id, nothing allocated */
	    }
	}

	# # ## ### ##### ######## ############# #####################
	## Event deletion on destruction is handled by the higher-level _unset functions.
	## They call <<Tcl_DeleteEvents (@stem@_callback_@@cname@@_delete, (ClientData) instance);>>

	# # ## ### ##### ######## ############# #####################
	field Tcl_Obj* command@@cname@@ \
	    {Command prefix for '@@name@@' events (@@group@@ aspect)}
    }]

    if {$mode ne "all"} {
	uplevel 1 [string map $map {
	    field int       queued@@cname@@ {Flag, true when a '@@name@@' event is queued}
	    field Tcl_Mutex mutex@@cname@@  {Mutex controlling access to the flag}

	    constructor {
		/* Initialize the mutex and queue flag for collapsed '@@name@@' events.*/
		instance->queued@@cname@@ = 0;
		instance->mutex@@cname@@  = 0;
	    }
	    destructor {
		/* Destroy mutex with instance */
		Tcl_MutexFinalize (&instance->mutex@@cname@@);
	    }

	    support {
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
	    }
	}]
    }

    uplevel 1 [string map $map {
	# # ## ### ##### ######## ############# #####################
	support {
	    /* Tcl Event Structure for '@@name@@'.
	     * The 'clientData
	     */
	    typedef struct @stem@_callback_@@cname@@_EVENT {
		Kinetcl_Event event;
		@instancetype@ instance;
                /* ----------------------------------------------------------------- */
		@@esignature@@
                /* ----------------------------------------------------------------- */
	    } @stem@_callback_@@cname@@_EVENT;
	}

	# # ## ### ##### ######## ############# #####################
        ## Kinetcl callback handler. Invoked from the event queue of
        ## the owning thread. The events are set up by the raw
        ## handler, see the next function.

	support {
	    static int
	    @stem@_callback_@@cname@@_tcl_handler (Tcl_Event* evPtr, int mask)
	    {
		@stem@_callback_@@cname@@_EVENT* e = (@stem@_callback_@@cname@@_EVENT*) evPtr;
		@instancetype@ instance;
                @@evardef@@
		Tcl_Obj* cmd;
		Tcl_Interp* interp;
		/* ASSERT (h == instance->handle) ? */

		/* Treating kinetcl's callbacks like fileevents, not
		 * processing them when not allowed by the core.
		 */
		if (!(mask & TCL_FILE_EVENTS)) { return 0; }
		instance = e->instance;
		@@edqguard@@

		/* Drop event '@@name@@' if no handler set. But also
		 * signal it as processed to get rid of it in the
		 * queue too. Note: This should not be necessary,
		 * given that the higher _unset functions drop all
		 * unprocessed events from the queue.
		 */
		if (!instance->command@@cname@@) {
		    @@edestructor@@
		    return 1;
		}

                /* Decode event structure into local variables. */
                @@edecode@@

                interp = instance->interp;
		cmd = Tcl_DuplicateObj (instance->command@@cname@@);
		Tcl_ListObjAppendElement (interp, cmd, instance->self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@name@@", -1));

		{ @@body@@ }
                @@edestructor@@

		/* Invoke "{*}$cmdprefix $self @@name@@ ..." */
		kinetcl_invoke_callback (interp, cmd);

                /* Signal that event was processed */
                return 1;
	    }
        }

	# # ## ### ##### ######## ############# #####################
        ## Callback handler function invoked by OpenNI. It does
        ## nothing more than setting up and enqueueing the call as
        ## event to be processed later.

	support {
	    static void
	    @stem@_callback_@@cname@@_free (Kinetcl_Event* evPtr)
	    {
                @stem@_callback_@@cname@@_EVENT* e = \
		    (@stem@_callback_@@cname@@_EVENT*) ckalloc (sizeof (@stem@_callback_@@cname@@_EVENT));
             
                /* Destroy this event, here we deal with the internal allocated parts */
                @@edestructor@@
                return 1;
            }

	    static void
	    @stem@_callback_@@cname@@_handler (@@signature@@)
	    {
                @instancetype@ instance = (@instancetype@) clientData;
                @stem@_callback_@@cname@@_EVENT* e;

		@@eeqguard@@

		e = (@stem@_callback_@@cname@@_EVENT*) ckalloc (sizeof (@stem@_callback_@@cname@@_EVENT));
                e->event.event.proc = @stem@_callback_@@cname@@_tcl_handler;
		e->event.delproc    = @stem@_callback_@@cname@@_free;
                e->instance = instance;
                @@eencode@@

		if (kinetcl_locked (instance->context, e)) return;

                Tcl_ThreadQueueEvent(instance->owner, (Tcl_Event *) e, TCL_QUEUE_TAIL);
                Tcl_ThreadAlert     (instance->owner);
            }
	}

	# # ## ### ##### ######## ############# #####################
        ## Handler invoked by Tcl_DeleteEvents (see instance destructor)
        ## Filters out Kinetcl events of the instance and marks them for destruction.
        ## nothing more than setting up and enqueueing the call as
        ## event to be processed later.

	support {
	    static int
	    @stem@_callback_@@cname@@_delete (Tcl_Event* evPtr, ClientData clientData)
	    {
                @instancetype@ instance = (@instancetype@) clientData;
                @stem@_callback_@@cname@@_EVENT* e = \
		    (@stem@_callback_@@cname@@_EVENT*) ckalloc (sizeof (@stem@_callback_@@cname@@_EVENT));

                /* Keep events not issued by Kinetcl */
                if (e->event.event.proc != @stem@_callback_@@cname@@_tcl_handler) {
		    return 0;
		}
                /* Keep events not issued by the instance about to be destroyed */
                if (e->instance != instance) {
		    return 0;
		}

		@@edqguard@@
		@stem@_callback_@@cname@@_free ((Kinetcl_Event*) e);
                return 1;
            }
	}

        # # ## ### ##### ######## ############# #####################
    }]
}

# # ## ### ##### ######## ############# #####################
return
