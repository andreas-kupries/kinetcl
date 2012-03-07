# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapCropping {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    mdef crop { /* Syntax: <instance> crop ?x y w h? */
	XnStatus s;
	XnCropping c;

	if (objc == 2) { /* Syntax: <instance> crop */
	    Tcl_Obj* cv[5];

	    s = xnGetCropping (instance->handle, &c);
	    CHECK_STATUS_RETURN;

	    cv [0] = Tcl_NewIntObj (c.bEnabled);
	    cv [1] = Tcl_NewIntObj (c.nXOffset);
	    cv [2] = Tcl_NewIntObj (c.nYOffset);
	    cv [3] = Tcl_NewIntObj (c.nXSize);
	    cv [4] = Tcl_NewIntObj (c.nYSize);

	    Tcl_SetObjResult (interp, Tcl_NewListObj (5, cv));
	    return TCL_OK;
	}

	if (objc == 6) { /* Syntax: <instance> crop x y w h */
	    int i;

	    if (Tcl_GetIntFromObj (interp, objv [2], &i) != TCL_OK) {
		return TCL_ERROR;
	    }
	    c.nXOffset = i;
	    if (Tcl_GetIntFromObj (interp, objv [3], &i) != TCL_OK) {
		return TCL_ERROR;
	    }
	    c.nYOffset = i;
	    if (Tcl_GetIntFromObj (interp, objv [4], &i) != TCL_OK) {
		return TCL_ERROR;
	    }
	    c.nXSize = i;
	    if (Tcl_GetIntFromObj (interp, objv [5], &i) != TCL_OK) {
		return TCL_ERROR;
	    }
	    c.nYSize = i;
	    c.bEnabled = 1;

	    s = xnSetCropping (instance->handle, &c);
	    CHECK_STATUS_RETURN;

	    return TCL_OK;
	}

	Tcl_WrongNumArgs (interp, 2, objv, "?x y w h?");
	return TCL_ERROR;
    }

    mdef uncrop { /* Syntax: <instance> uncrop */
	XnStatus s;
	XnCropping c;

	if (objc != 2) { /* Syntax: <instance> crop */
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	c.bEnabled = 0;
	c.nXOffset = 0;
	c.nYOffset = 0;
	c.nXSize = 0;
	c.nYSize = 0;

	s = xnSetCropping (instance->handle, &c);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    kt_callback cropping \
	xnRegisterToCroppingChange \
	xnUnregisterFromCroppingChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
