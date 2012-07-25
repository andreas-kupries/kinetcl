
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

    method set-smoothing {factor} {
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

    method start-tracking {point} {
	XnPoint3D p;
	XnStatus s;
	int pc;
	Tcl_Obj** pv;
	double px, py, pz;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "point");
	    return TCL_ERROR;
	}

	if (kinetcl_convert_to3d (interp, objv [2], &p) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnStartTracking (instance->handle, &p);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method stop-tracking {id} {
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

    method stop-tracking-all {} {
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
	hand-create {
	    {XnUserID         hand}
	    {const XnPoint3D* pPosition}
	    {XnFloat          fTime}
	} {
	    CB_DETAIL ("hand",     Tcl_NewIntObj (hand));
	    CB_DETAIL ("position", kinetcl_convert_3d (pPosition));
	    CB_DETAIL ("time",     Tcl_NewDoubleObj (fTime));
	} \
	hand-update {
	    {XnUserID         hand}
	    {const XnPoint3D* pPosition}
	    {XnFloat          fTime}
	} {
	    CB_DETAIL ("hand",     Tcl_NewIntObj (hand));
	    CB_DETAIL ("position", kinetcl_convert_3d (pPosition));
	    CB_DETAIL ("time",     Tcl_NewDoubleObj (fTime));
	} \
	hand-destroy {
	    {XnUserID         hand}
	    {XnFloat          fTime}
	} {
	    CB_DETAIL ("hand", Tcl_NewIntObj (hand));
	    CB_DETAIL ("time", Tcl_NewDoubleObj (fTime));
	}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
