# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapMirror {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############
    ## TODO: policy level classes for capabilities!

    method mirror command {objv[2] = ?bool?} {
	if (objc == 2) { /* Syntax: <instance> mirror */
	    XnBool m = xnIsMirrored (instance->handle);

	    Tcl_SetObjResult (interp, Tcl_NewIntObj (m));
	    return TCL_OK;
	}

	if (objc == 3) { /* Syntax: <instance> mirror bool */
	    XnStatus s;
	    int m;

	    if (Tcl_GetBooleanFromObj (interp, objv [2], &m) != TCL_OK) {
		return TCL_ERROR;
	    }

	    s = xnSetMirror (instance->handle, m);
	    CHECK_STATUS_RETURN;

	    return TCL_OK;
	}

	Tcl_WrongNumArgs (interp, 2, objv, "?bool?");
	return TCL_ERROR;
    }

    # # ## ### ##### ######## #############

    kt_callback mirror \
	xnRegisterToMirrorChange \
	xnUnregisterFromMirrorChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
