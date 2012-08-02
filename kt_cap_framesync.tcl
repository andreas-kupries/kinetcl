# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapFramesync {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method can-sync-with proc {XnNodeHandle other} bool {
	return xnCanFrameSyncWith (instance->handle, other);
    }

    method start-sync-with proc {XnNodeHandle other} ok {
	XnStatus s;

	s = xnFrameSyncWith (instance->handle, other);
	CHECK_STATUS_RETURN;
	return TCL_OK;
    }

    method stop-sync-with proc {XnNodeHandle other} ok {
	XnStatus s;

	s = xnStopFrameSyncWith (instance->handle, other);
	CHECK_STATUS_RETURN;
	return TCL_OK;
    }

    method synced-with proc {XnNodeHandle other} bool {
	return xnIsFrameSyncedWith (instance->handle, other);
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
