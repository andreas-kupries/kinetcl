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
    set esignature [list {XnNodeHandle h} {*}$signature {@instancetype@ instance}]
    set fsignature [list {XnNodeHandle h} {*}$signature {void* clientData}]

puts \n
puts \t[join $esignature \n\t]
puts \n

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
    lappend edestructor {ckfree ((char*) e);}

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
	    ### XXX destructor - clean up all unprocessed events of
	    ###     the instance.
	    ### XXX event collapsing - for some/most/whatever events
	    ###     it makes sense to not keep the individual events,
	    ###     but only the last. Example: newdata. For these we
	    ###     have to build a mechanism which ensures this.
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
	    static void
	    @stem@_callback_@@cname@@_tcl_handler (Tcl_Event* evPtr)
	    {
		@stem@_callback_@@cname@@_EVENT* e = (@stem@_callback_@@cname@@_EVENT*) evPtr;
                @@evardef@@
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		Tcl_Interp* interp;
		/* ASSERT (h == instance->handle) ? */

		/* Ignore event '@@name@@' if no handler set */
		if (!instance->command@@cname@@) return;

fprintf (stdout,"%u @ %s = (%p) [%p] @@cname@@\n", pthread_self(), Tcl_GetString (instance->self), instance, h);fflush(stdout);
return;
                /* Decode event structure into local variables. */
                @@edecode@@
                interp = instance->interp;

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cname@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@name@@", -1));

		{ @@body@@ }
                @@edestructor@@

		/* Invoke "{*}$cmdprefix $self @@name@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
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
                @@eencode@@

                Tcl_ThreadQueueEvent(instance->owner, (Tcl_Event *) e, TCL_QUEUE_TAIL);
                Tcl_ThreadAlert     (instance->owner);
            }
	}
    }]
}

# # ## ### ##### ######## ############# #####################
return
