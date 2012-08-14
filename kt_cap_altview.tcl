# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapAlternativeViewpoint {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method supports-view proc {XnNodeHandle other} bool {
	return xnIsViewPointSupported (instance->handle, other);
    }

    method set-view proc {XnNodeHandle other} XnStatus {
	return xnSetViewPoint (instance->handle, other);
    }

    method reset-view proc {} XnStatus {
	return xnResetViewPoint (instance->handle);
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
