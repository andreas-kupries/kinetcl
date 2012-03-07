# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapMirror {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    mdef mirror { /* Syntax: <instance> mirror <bool> */
	int m;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "bool");
	    return TCL_ERROR;
	}

	if (Tcl_GetBooleanFromObj (interp, objv[2], &m) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetMirror (instance->handle, m);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef mirrored { /* Syntax: <instance> mirrored */
	XnBool m;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	m = xnIsMirrored (instance->handle);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (m));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    kt_callback mirror \
	xnRegisterToMirrorChange \
	xnUnregisterFromMirrorChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
