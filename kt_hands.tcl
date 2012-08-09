
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

    method set-smoothing proc {double factor} XnStatus {
	return xnSetTrackingSmoothing (instance->handle, factor);
    }

    method start-tracking proc {XnPoint3D point} XnStatus {
	return xnStartTracking (instance->handle, &point);
    }

    method stop-tracking proc {int id} XnStatus {
	return xnStopTracking (instance->handle, id);
    }

    method stop-tracking-all proc {} XnStatus {
	return xnStopTrackingAll (instance->handle);
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
