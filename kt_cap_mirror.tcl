# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapMirrorC {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method @mirror: proc {bool mirror} XnStatus {
	return xnSetMirror (instance->handle, mirror);
    }

    method @mirror? proc {} bool {
	return xnIsMirrored (instance->handle);
    }

    # # ## ### ##### ######## #############

    kt_callback mirror \
	xnRegisterToMirrorChange \
	xnUnregisterFromMirrorChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
