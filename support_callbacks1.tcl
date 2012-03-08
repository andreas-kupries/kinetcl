## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we define how single callbacks are handled.

# # ## ### ##### ######## #############

proc kt_callback {name consfunction destfunction signature body} {
    set cname     [string totitle $name]
    set signature [join [list {XnNodeHandle h} {*}$signature {void* clientData}] {, }]

    lappend map @@cname@@         $cname 
    lappend map @@name@@          $name
    lappend map @@consfunction@@  $consfunction
    lappend map @@destfunction@@  $destfunction
    lappend map @@signature@@     $signature
    lappend map @@body@@          $body

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
	field Tcl_Obj*         command@@cname@@  {Command prefix for @@name@@ callbacks}

	constructor {
	    instance->callback@@cname@@ = NULL;
	    instance->command@@cname@@ = NULL;
	}

	destructor {
	    @stem@_callback_@@cname@@_unset (instance);
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

	    @stem@_callback_@@cname@@_unset (instance);
	    return TCL_ERROR;
	}

	support {
	    static void
	    @stem@_callback_@@cname@@_handler (@@signature@@)
	    {
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		@instancetype@ instance = (@instancetype@) clientData;
		Tcl_Interp* interp = instance->interp;
		/* ASSERT (h == instance->handle) ? */

fprintf (stdout,"%u @ %s = (%p) [%p] @@cname@@\n", pthread_self(), Tcl_GetString (instance->self), instance, h);fflush(stdout);
return;

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cname@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@name@@", -1));

		{ @@body@@ }

		/* Invoke "{*}$cmdprefix $self @@name@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
	    }

	    static void
	    @stem@_callback_@@cname@@_unset (@instancetype@ instance)
	    {
		if (!instance->callback@@cname@@) return;

		@@destfunction@@ (instance->handle, instance->callback@@cname@@);

		Tcl_DecrRefCount (instance->command@@cname@@);
		instance->callback@@cname@@ = NULL;
		instance->command@@cname@@ = NULL;
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

		@stem@_callback_@@cname@@_unset (instance);

		instance->callback@@cname@@ = callback;
		instance->command@@cname@@  = Tcl_NewListObj (objc, objv);
		return TCL_OK;
	    }
	}
    }]
}

# # ## ### ##### ######## #############
return
