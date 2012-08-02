# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapAlternativeViewpoint {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method supports-view proc {XnNodeHandle other} bool {
	return xnIsViewPointSupported (instance->handle, other);
    }

    method set-view proc {XnNodeHandle other} ok {
	XnStatus s;

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

    method using-view proc {XnNodeHandle other} bool {
	return xnIsViewPointAs (instance->handle, other);
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
