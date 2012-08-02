# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapFramesync {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method can-sync-with proc {Tcl_Obj* node} ok {
	XnNodeHandle other;
	XnBool supported;

	if (kinetcl_validate (interp, node, &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	supported = xnCanFrameSyncWith (instance->handle, other);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (supported));
	return TCL_OK;
    }

    method start-sync-with proc {Tcl_Obj* node} ok {
	XnStatus s;
	XnNodeHandle other;

	if (kinetcl_validate (interp, node, &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnFrameSyncWith (instance->handle, other);
	CHECK_STATUS_RETURN;
	return TCL_OK;
    }

    method stop-sync-with proc {Tcl_Obj* node} ok {
	XnStatus s;
	XnNodeHandle other;

	if (kinetcl_validate (interp, node, &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnStopFrameSyncWith (instance->handle, other);
	CHECK_STATUS_RETURN;
	return TCL_OK;
    }

    method synced-with proc {Tcl_Obj* node} ok {
	XnNodeHandle other;
	XnBool as;

	if (kinetcl_validate (interp, node, &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	as = xnIsFrameSyncedWith (instance->handle, other);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (as));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    kt_callback framesync \
	xnRegisterToFrameSyncChange \
	xnUnregisterFromFrameSyncChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
return
