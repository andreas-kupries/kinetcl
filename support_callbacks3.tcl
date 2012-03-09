## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we define how triple callbacks are handled and exposed to
## users. That are callbacks where OpenNI manages three related
## callbacks through a single (un)registration API.

# # ## ### ##### ######## #############

proc kt_3callback {name consfunction destfunction
		   namea signaturea bodya
		   nameb signatureb bodyb
		   namec signaturec bodyc
	       } {

    set cname      [string totitle $name]

    set cnamea     [string totitle $namea]
    set signaturea [join [list {XnNodeHandle h} {*}$signaturea {void* clientData}] {, }]

    set cnameb     [string totitle $nameb]
    set signatureb [join [list {XnNodeHandle h} {*}$signatureb {void* clientData}] {, }]

    set cnamec     [string totitle $namec]
    set signaturec [join [list {XnNodeHandle h} {*}$signaturec {void* clientData}] {, }]

    lappend map @@name@@          $name
    lappend map @@cname@@         $cname
    lappend map @@consfunction@@  $consfunction
    lappend map @@destfunction@@  $destfunction

    lappend map @@cnamea@@        $cnamea
    lappend map @@namea@@         $namea
    lappend map @@signaturea@@    $signaturea
    lappend map @@bodya@@         $bodya

    lappend map @@cnameb@@        $cnameb
    lappend map @@nameb@@         $nameb
    lappend map @@signatureb@@    $signatureb
    lappend map @@bodyb@@         $bodyb

    lappend map @@cnamec@@        $cnamec
    lappend map @@namec@@         $namec
    lappend map @@signaturec@@    $signaturec
    lappend map @@bodyc@@         $bodyc

    uplevel 1 [string map $map {
	catch {
	    field Tcl_Interp* interp {Interpreter in callback handlers}
	    constructor {
		instance->interp = interp;
	    }
	    destructor {
		/* instance->interp is a non-owned copy, nothing to do */
	    }
	}

	field XnCallbackHandle callback@@cname@@ {Handle for @@name@@ callbacks}
	field Tcl_Obj*         command@@cnamea@@ {Command prefix for @@namea@@ callbacks (@@name@@ aspect)}
	field Tcl_Obj*         command@@cnameb@@ {Command prefix for @@nameb@@ callbacks (@@name@@ aspect)}
	field Tcl_Obj*         command@@cnamec@@ {Command prefix for @@namec@@ callbacks (@@name@@ aspect)}

	constructor {
	    instance->callback@@cname@@ = NULL;
	    instance->command@@cnamea@@ = NULL;
	    instance->command@@cnameb@@ = NULL;
	    instance->command@@cnamec@@ = NULL;
	}

	destructor {
	    @stem@_callback_@@cnamea@@_unset (instance);
	    @stem@_callback_@@cnameb@@_unset (instance);
	    @stem@_callback_@@cnamec@@_unset (instance);
	}

	mdef set-callback-@@namea@@ { /* Syntax: <instance> set-callback-@@namea@@ <cmd>... */
	    if (objc < 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "cmd...");
		return TCL_ERROR;
	    }

	    return @stem@_callback_@@cnamea@@_set (instance, objc-2, objv+2);
	}

	mdef unset-callback-@@namea@@ { /* Syntax: <instance> unset-callback-@@namea@@ */
	    if (objc != 2) {
		Tcl_WrongNumArgs (interp, 2, objv, NULL);
		return TCL_OK;
	    }

	    @stem@_callback_@@cnamea@@_unset (instance);
	    return TCL_ERROR;
	}

	mdef set-callback-@@nameb@@ { /* Syntax: <instance> set-callback-@@nameb@@ <cmd>... */
	    if (objc < 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "cmd...");
		return TCL_ERROR;
	    }

	    return @stem@_callback_@@cnameb@@_set (instance, objc-2, objv+2);
	}

	mdef unset-callback-@@nameb@@ { /* Syntax: <instance> unset-callback-@@nameb@@ */
	    if (objc != 2) {
		Tcl_WrongNumArgs (interp, 2, objv, NULL);
		return TCL_OK;
	    }

	    @stem@_callback_@@cnameb@@_unset (instance);
	    return TCL_ERROR;
	}

	mdef set-callback-@@namec@@ { /* Syntax: <instance> set-callback-@@namec@@ <cmd>... */
	    if (objc < 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "cmd...");
		return TCL_ERROR;
	    }

	    return @stem@_callback_@@cnamec@@_set (instance, objc-2, objv+2);
	}

	mdef unset-callback-@@namec@@ { /* Syntax: <instance> unset-callback-@@namec@@ */
	    if (objc != 2) {
		Tcl_WrongNumArgs (interp, 2, objv, NULL);
		return TCL_OK;
	    }

	    @stem@_callback_@@cnamec@@_unset (instance);
	    return TCL_ERROR;
	}

	support {
	    static void
	    @stem@_callback_@@cnamea@@_handler (@@signaturea@@)
	    {
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		@instancetype@ instance = (@instancetype@) clientData;
		Tcl_Interp* interp = instance->interp;
		/* ASSERT (h == instance->handle) ? */

fprintf (stdout,"%u @ %s = (%p) [%p] @@cnamea@@\n", pthread_self(), Tcl_GetString (instance->self), instance, h);fflush(stdout);
return;

		/* Ignore callback @@namea@@ if not set */
		if (!instance->command@@cnamea@@) return;

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cnamea@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@namea@@", -1));

		{ @@bodya@@ }

		/* Invoke "{*}$cmdprefix $self @@namea@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
	    }

	    static void
	    @stem@_callback_@@cnameb@@_handler (@@signatureb@@)
	    {
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		Tcl_InterpState saved;
		@instancetype@ instance = (@instancetype@) clientData;
		Tcl_Interp* interp = instance->interp;
		/* ASSERT (h == instance->handle) ? */

fprintf (stdout,"%u @ %s = (%p) [%p] @@cnameb@@\n", pthread_self(), Tcl_GetString (instance->self), instance, h);fflush(stdout);
return;

		/* Ignore callback @@nameb@@ if not set */
		if (!instance->command@@cnameb@@) return;

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cnameb@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@nameb@@", -1));

		{ @@bodyb@@ }

		/* Invoke "{*}$cmdprefix $self @@nameb@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
	    }

	    static void
	    @stem@_callback_@@cnamec@@_handler (@@signaturec@@)
	    {
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		Tcl_InterpState saved;
		@instancetype@ instance = (@instancetype@) clientData;
		Tcl_Interp* interp = instance->interp;
		/* ASSERT (h == instance->handle) ? */

fprintf (stdout,"%u @ %s = (%p) [%p] @@cnamec@@\n", pthread_self(), Tcl_GetString (instance->self), instance, h);fflush(stdout);
return;

		/* Ignore callback @@namec@@ if not set */
		if (!instance->command@@cnamec@@) return;

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cnamec@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@namec@@", -1));

		{ @@bodyc@@ }

		/* Invoke "{*}$cmdprefix $self @@namec@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
	    }

	    static void
	    @stem@_callback_@@cnamea@@_unset (@instancetype@ instance)
	    {
		/* Single callback handle for 2 callbacks */
		if (!instance->callback@@cname@@) return;
                if (!instance->command@@cnamea@@) return;

		Tcl_DecrRefCount (instance->command@@cnamea@@);
		instance->command@@cnamea@@ = NULL;

		/* Keep C callback if other Tcl callbacks still active */
		if (instance->command@@cnameb@@) return;
		if (instance->command@@cnamec@@) return;

		@@destfunction@@ (instance->handle, instance->callback@@cname@@);
		instance->callback@@cname@@ = NULL;
	    }

	    static void
	    @stem@_callback_@@cnameb@@_unset (@instancetype@ instance)
	    {
		/* Single callback handle for 2 callbacks */
		if (!instance->callback@@cname@@) return;
                if (!instance->command@@cnameb@@) return;

		Tcl_DecrRefCount (instance->command@@cnameb@@);
		instance->command@@cnameb@@ = NULL;

		/* Keep C callback if other Tcl callback still active */
		if (instance->command@@cnamea@@) return;
		if (instance->command@@cnamec@@) return;

		@@destfunction@@ (instance->handle, instance->callback@@cname@@);
		instance->callback@@cname@@ = NULL;
	    }

	    static void
	    @stem@_callback_@@cnamec@@_unset (@instancetype@ instance)
	    {
		/* Single callback handle for 2 callbacks */
		if (!instance->callback@@cname@@) return;
                if (!instance->command@@cnamec@@) return;

		Tcl_DecrRefCount (instance->command@@cnamec@@);
		instance->command@@cnamec@@ = NULL;

		/* Keep C callback if other Tcl callback still active */
		if (instance->command@@cnamea@@) return;
		if (instance->command@@cnameb@@) return;

		@@destfunction@@ (instance->handle, instance->callback@@cname@@);
		instance->callback@@cname@@ = NULL;
	    }


	    static int
	    @stem@_callback_@@cnamea@@_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	    {
		Tcl_Obj* cmd;

		if (!instance->callback@@cname@@) {
		    Tcl_Interp* interp = instance->interp;
		    XnCallbackHandle callback;
		    XnStatus s;

		    s = @@consfunction@@ (instance->handle,
					  @stem@_callback_@@cnamea@@_handler,
					  @stem@_callback_@@cnameb@@_handler,
					  @stem@_callback_@@cnamec@@_handler,
					  instance,
					  &callback);
		    CHECK_STATUS_RETURN;

		    instance->callback@@cname@@ = callback;
		}

		@stem@_callback_@@cnamea@@_unset (instance);
		instance->command@@cnamea@@ = Tcl_NewListObj (objc, objv);
		return TCL_OK;
	    }

	    static int
	    @stem@_callback_@@cnameb@@_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	    {
		Tcl_Obj* cmd;

		if (!instance->callback@@cname@@) {
		    Tcl_Interp* interp = instance->interp;
		    XnCallbackHandle callback;
		    XnStatus s;

		    s = @@consfunction@@ (instance->handle,
					  @stem@_callback_@@cnamea@@_handler,
					  @stem@_callback_@@cnameb@@_handler,
					  @stem@_callback_@@cnamec@@_handler,
					  instance,
					  &callback);
		    CHECK_STATUS_RETURN;

		    instance->callback@@cname@@ = callback;
		}

		@stem@_callback_@@cnameb@@_unset (instance);
		instance->command@@cnameb@@ = Tcl_NewListObj (objc, objv);
		return TCL_OK;
	    }

	    static int
	    @stem@_callback_@@cnamec@@_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	    {
		Tcl_Obj* cmd;

		if (!instance->callback@@cname@@) {
		    Tcl_Interp* interp = instance->interp;
		    XnCallbackHandle callback;
		    XnStatus s;

		    s = @@consfunction@@ (instance->handle,
					  @stem@_callback_@@cnamea@@_handler,
					  @stem@_callback_@@cnameb@@_handler,
					  @stem@_callback_@@cnamec@@_handler,
					  instance,
					  &callback);
		    CHECK_STATUS_RETURN;

		    instance->callback@@cname@@ = callback;
		}

		@stem@_callback_@@cnamec@@_unset (instance);
		instance->command@@cnamec@@ = Tcl_NewListObj (objc, objv);
		return TCL_OK;
	    }
	}
    }]
}

# # ## ### ##### ######## #############
return
