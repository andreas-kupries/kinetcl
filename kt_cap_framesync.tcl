# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapFramesync {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    mdef can-sync-with { /* Syntax: <instance> can-sync <other-node> */
	XnNodeHandle other;
	XnBool supported;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "node");
	    return TCL_ERROR;
	}

	if (kinetcl_validate (interp, objv [2], &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	supported = xnCanFrameSyncWith (instance->handle, other);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (supported));
	return TCL_OK;
    }

    mdef start-sync-with { /* Syntax: <instance> start-sync-with <other-node> */
	XnStatus s;
	XnNodeHandle other;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "node");
	    return TCL_ERROR;
	}

	if (kinetcl_validate (interp, objv [2], &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnFrameSyncWith (instance->handle, other);
	CHECK_STATUS_RETURN;
	return TCL_OK;
    }

    mdef stop-sync-with { /* Syntax: <instance> stop-sync-with <other-node> */
	XnStatus s;
	XnNodeHandle other;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "node");
	    return TCL_ERROR;
	}

	if (kinetcl_validate (interp, objv [2], &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnStopFrameSyncWith (instance->handle, other);
	CHECK_STATUS_RETURN;
	return TCL_OK;
    }

    mdef synced-with { /* Syntax: <instance> synced-with <other-node> */
	XnNodeHandle other;
	XnBool as;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "node");
	    return TCL_ERROR;
	}

	if (kinetcl_validate (interp, objv [2], &other) != TCL_OK) {
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
