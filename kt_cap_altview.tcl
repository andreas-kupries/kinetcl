# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapAlternativeViewpoint {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    mdef supports-view { /* Syntax: <instance> supports-view <other-node> */
	XnNodeHandle other;
	XnBool supported;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "node");
	    return TCL_ERROR;
	}

	if (kinetcl_validate (interp, objv [2], &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	supported = xnIsViewPointSupported (instance->handle, other);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (supported));
	return TCL_OK;
    }

    mdef set-view { /* Syntax: <instance> set-view <other-node> */
	XnStatus s;
	XnNodeHandle other;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "node");
	    return TCL_ERROR;
	}

	if (kinetcl_validate (interp, objv [2], &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetViewPoint (instance->handle, other);
	CHECK_STATUS_RETURN;
	return TCL_OK;
    }

    mdef reset-view { /* Syntax: <instance> reset-view */
	XnStatus s;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnResetViewPoint (instance->handle);
	CHECK_STATUS_RETURN;
	return TCL_OK;
    }

    mdef using-view { /* Syntax: <instance> using-view <other-node> */
	XnNodeHandle other;
	XnBool as;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "node");
	    return TCL_ERROR;
	}

	if (kinetcl_validate (interp, objv [2], &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	as = xnIsViewPointAs (instance->handle, other);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (as));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    kt_callback viewpoint \
	xnRegisterToViewPointChange \
	xnUnregisterFromViewPointChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
return
