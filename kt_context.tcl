## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines the per-intepreter structures collecting
## information relevant to the whole package, i.e. all classes and
## instances. All classes, and instances will have a reference to this
## structure which is initialized at class and instance construction
## time, via kinetcl_context ().

critcl::buildrequirement {
    package require critcl::iassoc
}

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
