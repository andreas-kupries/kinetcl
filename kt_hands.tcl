
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

    method set-smoothing proc {double factor} ok {
	XnStatus s;

	s = xnSetTrackingSmoothing (instance->handle, factor);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method start-tracking proc {Tcl_Obj* point} ok {
	XnPoint3D p;
	XnStatus s;
	int pc;
	Tcl_Obj** pv;
	double px, py, pz;

	if (kinetcl_convert_to3d (interp, point, &p) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnStartTracking (instance->handle, &p);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method stop-tracking proc {int id} ok {
	XnStatus s;

	s = xnStopTracking (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method stop-tracking-all proc {} ok {
	XnStatus s;

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
