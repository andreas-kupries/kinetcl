## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines the per-intepreter structures collecting
## information relevant to the whole package, i.e. all classes and
## instances. All classes, and instances will have a reference to this
## structure which is initialized at class and instance construction
## time, via kinetcl_context ().

# # ## ### ##### ######## #############

critcl::buildrequirement {
    package require critcl::iassoc
}

# # ## ### ##### ######## #############

critcl::ccode {
    #include <XnOpenNI.h>

#define CHECK_STATUS_RETURN \
	if (s != XN_STATUS_OK) { \
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL); \
	    return TCL_ERROR; \
	}

#define CHECK_STATUS_GOTO \
	if (s != XN_STATUS_OK) { \
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL); \
	    goto error; \
	}
}

# # ## ### ##### ######## #############

critcl::iassoc::def kinetcl_context {} {
    /* Our OpenNI context
     */
    XnContext* context;

    /* The stash/cache used by instances to propagate their handle to
     * base classes without having to expose the handle/pointer to the
     * Tcl level.
     */
    XnNodeHandle mark;
} {
    XnStatus s = xnInit (&data->context);

    if (s != XN_STATUS_OK) {
	Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	goto error;
    }
} {
    xnContextRelease (data->context);
}

# # ## ### ##### ######## #############
## Validation at C-level. Calls out to Tcl, where this was much easier
## to implement.  Automatically cleans up the stash through which the
## handle is communicated to us. Nothing the caller has to bother
## with.

critcl::ccode {
    static int
    kinetcl_validate (Tcl_Interp* interp, Tcl_Obj* o, XnNodeHandle* handle)
    {
	kinetcl_context_data c;
	Tcl_Obj* cv [2];

	cv [0] = Tcl_NewStringObj ("::kinetcl::Valid",-1);
	cv [1] = o;

	if (Tcl_EvalObjv (interp, 2, cv, 0) != TCL_OK) {
	    return TCL_ERROR;
	}

	c = kinetcl_context (interp);

	*handle = c->mark;
	c->mark = NULL;
	return TCL_OK;
    }
}

# # ## ### ##### ######## #############

critcl::cproc ::kinetcl::start {Tcl_Interp* interp} ok {
    XnStatus s = xnStartGeneratingAll (kinetcl_context (interp)->context);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

critcl::cproc ::kinetcl::stop {Tcl_Interp* interp} ok {
    XnStatus s = xnStopGeneratingAll (kinetcl_context (interp)->context);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

# # ## ### ##### ######## #############

critcl::cproc ::kinetcl::waitUpdate {Tcl_Interp* interp} ok {
    XnStatus s = xnWaitAndUpdateAll (kinetcl_context (interp)->context);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

critcl::cproc ::kinetcl::waitAnyUpdate {Tcl_Interp* interp} ok {
    XnStatus s = xnWaitAnyUpdateAll (kinetcl_context (interp)->context);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

critcl::cproc ::kinetcl::waitNoneUpdate {Tcl_Interp* interp} ok {
    XnStatus s = xnWaitNoneUpdateAll (kinetcl_context (interp)->context);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

critcl::cproc ::kinetcl::waitOneUpdate {Tcl_Interp* interp Tcl_Obj* o} ok {
    XnStatus s;
    kinetcl_context_data c = kinetcl_context (interp);
    XnNodeHandle handle;

    if (kinetcl_validate (interp, o, &handle) != TCL_OK) {
	return TCL_ERROR;
    }

    s = xnWaitOneUpdateAll (c->context, handle);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

# # ## ### ##### ######## #############

critcl::cproc ::kinetcl::errorstate {Tcl_Interp* interp} ok {
    XnStatus s = xnGetGlobalErrorState (kinetcl_context (interp)->context);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

# # ## ### ##### ######## #############

critcl::ccommand ::kinetcl::mirror {} {  /* Syntax: mirror ?bool? */
    kinetcl_context_data c = kinetcl_context (interp);

    if (objc == 1) { /* Syntax: mirror */
	XnBool m = xnGetGlobalMirror (c->context);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (m));
	return TCL_OK;
    }

    if (objc == 2) { /* Syntax: mirror bool */
	XnStatus s;
	int      m;

	if (Tcl_GetBooleanFromObj (interp, objv [1], &m) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetGlobalMirror (c->context, m);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    Tcl_WrongNumArgs (interp, 1, objv, "?bool?");
    return TCL_ERROR;
}

# # ## ### ##### ######## #############
## Need a way for the kt_callback to operate without a class around it.
if 0 {
XnStatus xnRegisterToGlobalErrorStateChange     (XnContext *pContext, XnErrorStateChangedHandler handler, void *pCookie, XnCallbackHandle *phCallback)
void 	 xnUnregisterFromGlobalErrorStateChange (XnContext *pContext, XnCallbackHandle hCallback)
}
# # ## ### ##### ######## #############
return
