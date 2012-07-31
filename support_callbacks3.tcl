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
    # The additional offsets (3 and 1 == \n\n\n, \n) are added because
    # of the way we are formatting the calls of this procedure with
    # continuation lines between the first four arguments and after
    # the first and second body.
    critcl::at::caller
    critcl::at::incrt \n\n\n        $signaturea  ; set aloc [critcl::at::get*]
    critcl::at::incrt \n     $bodya $signatureb  ; set bloc [critcl::at::get*]
    critcl::at::incrt \n     $bodyb $signaturec  ; set cloc [critcl::at::get]

    set cname  [kt_cbcname $name]
    set cnamea [kt_cbcname $namea]
    set cnameb [kt_cbcname $nameb]
    set cnamec [kt_cbcname $namec]

    # Define the raw callback processing.
    kt_cbhandler $name $namea $cnamea $signaturea $aloc$bodya
    kt_cbhandler $name $nameb $cnameb $signatureb $bloc$bodyb
    kt_cbhandler $name $namec $cnamec $signaturec $cloc$bodyc

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

    # The command@@...@@ structures used later are defined by
    # kt_cbhandler above.

    insvariable XnCallbackHandle callback$cname "
	Handle for $name callbacks
    " [string map $map {
	instance->callback@@cname@@ = NULL;
    }] [string map $map {
	@stem@_callback_@@cnamea@@_unset (instance, 1);
	@stem@_callback_@@cnameb@@_unset (instance, 1);
	@stem@_callback_@@cnamec@@_unset (instance, 1);
    }]

    method set-callback-$namea {cmdprefix/2} [string map $map {
	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "cmdprefix");
	    return TCL_ERROR;
	}

	return @stem@_callback_@@cnamea@@_set (instance, objv [2]);
    }]

    method unset-callback-$namea {} [string map $map {
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	@stem@_callback_@@cnamea@@_unset (instance, 1);
	return TCL_OK;
    }]

    method set-callback-$nameb {cmdprefix/2} [string map $map {
	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "cmdprefix");
	    return TCL_OK;
	}

	return @stem@_callback_@@cnameb@@_set (instance, objv [2]);
    }]

    method unset-callback-$nameb {} [string map $map {
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	@stem@_callback_@@cnameb@@_unset (instance, 1);
	return TCL_OK;
    }]

    method set-callback-$namec {cmdprefix/2} [string map $map {
	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "cmdprefix");
	    return TCL_OK;
	}

	return @stem@_callback_@@cnamec@@_set (instance, objv [2]);
    }]

    method unset-callback-$namec {} [string map $map {
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	@stem@_callback_@@cnamec@@_unset (instance, 1);
	return TCL_OK;
    }]

    support [string map $map {
	static void
	@stem@_callback_@@cnamea@@_unset (@instancetype@ instance, int dev)
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

	    if (!dev) return;
	    Tcl_DeleteEvents (@stem@_callback_@@cnamea@@_delete, (ClientData) instance);
	}

	static void
	@stem@_callback_@@cnameb@@_unset (@instancetype@ instance, int dev)
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

	    if (!dev) return;
	    Tcl_DeleteEvents (@stem@_callback_@@cnameb@@_delete, (ClientData) instance);
	}

	static void
	@stem@_callback_@@cnamec@@_unset (@instancetype@ instance, int dev)
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

	    if (!dev) return;
	    Tcl_DeleteEvents (@stem@_callback_@@cnamec@@_delete, (ClientData) instance);
	}


	static int
	@stem@_callback_@@cnamea@@_set (@instancetype@ instance, Tcl_Obj* cmdprefix)
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

	    @stem@_callback_@@cnamea@@_unset (instance, 0);
	    instance->command@@cnamea@@ = cmdprefix;
	    Tcl_IncrRefCount (cmdprefix);
	    return TCL_OK;
	}

	static int
	@stem@_callback_@@cnameb@@_set (@instancetype@ instance, Tcl_Obj* cmdprefix)
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

	    @stem@_callback_@@cnameb@@_unset (instance, 0);
	    instance->command@@cnameb@@ = cmdprefix;
	    Tcl_IncrRefCount (cmdprefix);
	    return TCL_OK;
	}

	static int
	@stem@_callback_@@cnamec@@_set (@instancetype@ instance, Tcl_Obj* cmdprefix)
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

	    @stem@_callback_@@cnamec@@_unset (instance, 0);
	    instance->command@@cnamec@@ = cmdprefix;
	    Tcl_IncrRefCount (cmdprefix);
	    return TCL_OK;
	}
    }]
    return
}

# # ## ### ##### ######## #############
return
