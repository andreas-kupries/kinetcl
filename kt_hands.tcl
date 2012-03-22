
# # ## ### ##### ######## #############
## Hands Generator

critcl::class def ::kinetcl::Hands {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain hands generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateHandsGenerator (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############

    mdef set-smoothing { /* Syntax: <instance> set-smoothing <factor> */
	double factor;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "factor");
	    return TCL_ERROR;
	}

	if (Tcl_GetDoubleFromObj (interp, objv[2], &factor) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetTrackingSmoothing (instance->handle, factor);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef start-tracking { /* Syntax: <instance> start-tracking <point> */
	XnPoint3D p;
	XnStatus s;
	int pc;
	Tcl_Obj** pv;
	double px, py, pz;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "point");
	    return TCL_ERROR;
	}

	if (Tcl_ListObjGetElements (interp, objv[2], &pc, &pv) != TCL_OK) {
	    return TCL_ERROR;
	} else if (pc != 3) {
	    Tcl_AppendResult (interp, "Expected point (3 coordinates)", NULL);
	    return TCL_ERROR;
	}

	/* TODO : Write general code for tcl -> 3d point conversion */

	if (Tcl_GetDoubleFromObj (interp, pv [0], &px) != TCL_OK) {
	    return TCL_ERROR;
	}
	if (Tcl_GetDoubleFromObj (interp, pv [1], &py) != TCL_OK) {
	    return TCL_ERROR;
	}
	if (Tcl_GetDoubleFromObj (interp, pv [2], &pz) != TCL_OK) {
	    return TCL_ERROR;
	}

	p.X = px;
	p.Y = py;
	p.Z = pz;

	s = xnStartTracking (instance->handle, &p);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef stop-tracking { /* Syntax: <instance> stop-tracking <id> */
	int id;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnStopTracking (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef stop-tracking-all { /* Syntax: <instance> stop-tracking-all */
	XnStatus s;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnStopTrackingAll (instance->handle);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    ::kt_3callback hand \
	xnRegisterHandCallbacks \
	xnUnregisterHandCallbacks \
	handCreate {
	    {XnUserID         user}
	    {const XnPoint3D* pPosition}
	    {XnFloat          fTime}
	} {
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewIntObj (user));
	    Tcl_ListObjAppendElement (interp, cmd, kinetcl_convert_3d (pPosition));
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3,coord));
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewDoubleObj (fTime));
	} \
	handUpdate {
	    {XnUserID         user}
	    {const XnPoint3D* pPosition}
	    {XnFloat          fTime}
	} {
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewIntObj (user));
	    Tcl_ListObjAppendElement (interp, cmd, kinetcl_convert_3d (pPosition));
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewDoubleObj (fTime));
	} \
	handDestroy {
	    {XnUserID         user}
	    {XnFloat          fTime}
	} {
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewIntObj (user));
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewDoubleObj (fTime));
	}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
