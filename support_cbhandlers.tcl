## -*- tcl -*-
# # ## ### ##### ######## ############# #####################

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we define the processing of callbacks going from the raw
## OpenNI call to associated Tcl handler command.

# # ## ### ##### ######## ############# #####################

proc kt_cbhandler {group name cname signature body} {
    set esignature [list {XnNodeHandle h} {*}$signature]
    set fsignature [list {XnNodeHandle h} {*}$signature {void* clientData}]

    foreach parameter $esignature {
	set ptype     [join [lrange $parameter 0 end-1] { }]
	set pvariable [lindex $parameter end]

	if {[string match {*XnChar\*} $ptype]} {
	    # String pointer. Event gets a dynamically allocated copy.
	    lappend eencode     "e->$pvariable = strdup ($pvariable);"
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
	    ### XXX event collapsing - for some/most/whatever events
	    ###     it makes sense to not keep the individual events,
	    ###     but only the last. Example: newdata. For these we
	    ###     have to build a mechanism which ensures this.
	}

	destructor {
	    /* Delete all @@cname@@ events not yet processed and refering to the
	     * destroyed instance.
	     */
	    Tcl_DeleteEvents (@stem@_callback_@@cname@@_delete, (ClientData) instance);
	}

	# # ## ### ##### ######## ############# #####################
	field Tcl_Obj* command@@cname@@ \
	    {Command prefix for '@@name@@' events (@@group@@ aspect)}

	# # ## ### ##### ######## ############# #####################
	support {
	    /* Tcl Event Structure for '@@name@@'.
	     * The 'clientData
	     */
	    typedef struct @stem@_callback_@@cname@@_EVENT {
		Tcl_Event event;
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

		/* Drop event '@@name@@' if no handler set. But also signal it as
		 * processed to get rid of it in the queue too.
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
	    @stem@_callback_@@cname@@_handler (@@signature@@)
	    {
                @instancetype@ instance = (@instancetype@) clientData;
                @stem@_callback_@@cname@@_EVENT* e = (@stem@_callback_@@cname@@_EVENT*) ckalloc (sizeof (@stem@_callback_@@cname@@_EVENT));

                e->event.proc = @stem@_callback_@@cname@@_tcl_handler;
                e->instance = instance;
                @@eencode@@

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
                @stem@_callback_@@cname@@_EVENT* e = (@stem@_callback_@@cname@@_EVENT*) ckalloc (sizeof (@stem@_callback_@@cname@@_EVENT));

                /* Keep events not issued by Kinetcl */
                if (e->event.proc != @stem@_callback_@@cname@@_tcl_handler) {
		    return 0;
		}
                /* Keep events not issued by the instance about to be destroyed */
                if (e->instance != instance) {
		    return 0;
		}
             
                /* Destroy this event, here we deal with the internal allocated parts */
                @@edestructor@@
                return 1;
            }
	}

        # # ## ### ##### ######## ############# #####################
    }]
}

# # ## ### ##### ######## ############# #####################
return
