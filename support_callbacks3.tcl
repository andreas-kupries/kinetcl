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
    set cname  [string totitle $name]
    set cnamea [string totitle $namea]
    set cnameb [string totitle $nameb]
    set cnamec [string totitle $namec]

    # Define the raw callback processing.
    uplevel 1 [list kt_cbhandler $name $namea $cnamea $signaturea $bodya]
    uplevel 1 [list kt_cbhandler $name $nameb $cnameb $signatureb $bodyb]
    uplevel 1 [list kt_cbhandler $name $namec $cnamec $signaturec $bodyc]

    lappend map @@name@@          $name
    lappend map @@cname@@         $cname
    lappend map @@consfunction@@  $consfunction
    lappend map @@destfunction@@  $destfunction

    lappend map @@cnamea@@        $cnamea
    lappend map @@namea@@         $namea

    lappend map @@cnameb@@        $cnameb
    lappend map @@nameb@@         $nameb

    lappend map @@cnamec@@        $cnamec
    lappend map @@namec@@         $namec

    uplevel 1 [string map $map {
	field XnCallbackHandle callback@@cname@@ {Handle for @@name@@ callbacks}

	# The command@@...@@ structures comes from kt_cbhandler.

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
