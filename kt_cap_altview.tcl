# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapAlternativeViewpoint {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method supports-view proc {Tcl_Obj* node} ok {
	XnNodeHandle other;
	XnBool supported;

	if (kinetcl_validate (interp, node, &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	supported = xnIsViewPointSupported (instance->handle, other);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (supported));
	return TCL_OK;
    }

    method set-view proc {Tcl_Obj* node} ok {
	XnStatus s;
	XnNodeHandle other;

	if (kinetcl_validate (interp, node, &other) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetViewPoint (instance->handle, other);
	CHECK_STATUS_RETURN;
	return TCL_OK;
    }

    method reset-view proc {} ok {
	XnStatus s;

	s = xnResetViewPoint (instance->handle);
	CHECK_STATUS_RETURN;
	return TCL_OK;
    }

    method using-view proc {Tcl_Obj* node} ok {
	XnNodeHandle other;
	XnBool as;

	if (kinetcl_validate (interp, node, &other) != TCL_OK) {
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
