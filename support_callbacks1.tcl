## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we define how single callbacks are handled.

# # ## ### ##### ######## #############

proc kt_callback {name consfunction destfunction signature body {mode all} {detail {}}} {
    # The additional offset (3 == \n\n\n) gets added because of the
    # way we are formatting the calls of this procedure, with
    # continuation lines between the first four arguments.
    critcl::at::caller
    critcl::at::incrt \n\n\n $signature
    set bloc [critcl::at::get*]

    set cname [kt_cbcname $name]

    # Define the raw callback processing.
    kt_cbhandler $name $name $cname $signature $bloc$body $mode

    if {$detail ne {}} {
	set detail " \"$detail\","
    }

    lappend map @@cname@@         $cname 
    lappend map @@name@@          $name
    lappend map @@consfunction@@  $consfunction
    lappend map @@destfunction@@  $destfunction
    lappend map @@detail@@        $detail

    # The command@@...@@ structure used later is defined by
    # kt_cbhandler above

    insvariable XnCallbackHandle callback$cname "
	Handle for $name callbacks
    " [string map $map {
	instance->callback@@cname@@ = NULL;
    }] [string map $map {
	@stem@_callback_@@cname@@_unset (instance, 1);
    }]

    method set-callback-$name {cmdprefix/2} [string map $map {
	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "cmd...");
	    return TCL_OK;
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

    support [string map $map {
	static void
	@stem@_callback_@@cname@@_unset (@instancetype@ instance, int dev)
	{
	    if (!instance->callback@@cname@@) return;

	    @@destfunction@@ (instance->handle,@@detail@@ instance->callback@@cname@@);

	    Tcl_DecrRefCount (instance->command@@cname@@);
	    instance->callback@@cname@@ = NULL;
	    instance->command@@cname@@ = NULL;

	    if (!dev) return;
	    Tcl_DeleteEvents (@stem@_callback_@@cname@@_delete, (ClientData) instance);
	}

	static int
	@stem@_callback_@@cname@@_set (@instancetype@ instance, Tcl_Obj* cmdprefix)
	{
	    Tcl_Obj* cmd;
	    XnCallbackHandle callback;
	    XnStatus s;
	    Tcl_Interp* interp = instance->interp;

	    s = @@consfunction@@ (instance->handle,@@detail@@
				  @stem@_callback_@@cname@@_handler,
				  instance,
				  &callback);
	    CHECK_STATUS_RETURN;

	    @stem@_callback_@@cname@@_unset (instance, 0);

	    instance->callback@@cname@@ = callback;
	    instance->command@@cname@@  = cmdprefix;
	    Tcl_IncrRefCount (cmdprefix);
	    return TCL_OK;
	}
    }]
    return
}

# # ## ### ##### ######## #############
return
