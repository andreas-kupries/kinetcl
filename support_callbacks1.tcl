## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we define how single callbacks are handled.

# # ## ### ##### ######## #############

proc kt_callback {name consfunction destfunction signature body {mode all}} {
    set cname [string totitle $name]

    # Define the raw callback processing.
    uplevel 1 [list kt_cbhandler $name $name $cname $signature $body $mode]

    lappend map @@cname@@         $cname 
    lappend map @@name@@          $name
    lappend map @@consfunction@@  $consfunction
    lappend map @@destfunction@@  $destfunction

    uplevel 1 [string map $map {
	field XnCallbackHandle callback@@cname@@ {Handle for @@name@@ callbacks}

	# The command@@...@@ structure comes from kt_cbhandler.

	constructor {
	    instance->callback@@cname@@ = NULL;
	    instance->command@@cname@@ = NULL;
	}

	destructor {
	    @stem@_callback_@@cname@@_unset (instance, 1);
	}

	mdef set-callback-@@name@@ { /* Syntax: <instance> set-callback-@@name@@ <cmd>... */
	    if (objc < 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "cmd...");
		return TCL_ERROR;
	    }

	    return @stem@_callback_@@cname@@_set (instance, objc-2, objv+2);
	}

	mdef unset-callback-@@name@@ { /* Syntax: <instance> unset-callback-@@name@@ */
	    if (objc != 2) {
		Tcl_WrongNumArgs (interp, 2, objv, NULL);
		return TCL_OK;
	    }

	    @stem@_callback_@@cname@@_unset (instance, 1);
	    return TCL_ERROR;
	}

	support {
	    static void
	    @stem@_callback_@@cname@@_unset (@instancetype@ instance, int dev)
	    {
		if (!instance->callback@@cname@@) return;

		@@destfunction@@ (instance->handle, instance->callback@@cname@@);

		Tcl_DecrRefCount (instance->command@@cname@@);
		instance->callback@@cname@@ = NULL;
		instance->command@@cname@@ = NULL;

		if (!dev) return;
		Tcl_DeleteEvents (@stem@_callback_@@cname@@_delete, (ClientData) instance);
	    }

	    static int
	    @stem@_callback_@@cname@@_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	    {
		Tcl_Obj* cmd;
		XnCallbackHandle callback;
		XnStatus s;
		Tcl_Interp* interp = instance->interp;

		s = @@consfunction@@ (instance->handle,
				      @stem@_callback_@@cname@@_handler,
				      instance,
				      &callback);
		CHECK_STATUS_RETURN;

		@stem@_callback_@@cname@@_unset (instance, 0);

		instance->callback@@cname@@ = callback;
		instance->command@@cname@@  = Tcl_NewListObj (objc, objv);
		return TCL_OK;
	    }
	}
    }]
}

# # ## ### ##### ######## #############
return
