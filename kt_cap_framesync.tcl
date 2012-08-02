# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapFramesync {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method can-sync-with proc {XnNodeHandle other} bool {
	return xnCanFrameSyncWith (instance->handle, other);
    }

    method start-sync-with proc {XnNodeHandle other} XnStatus {
	return xnFrameSyncWith (instance->handle, other);
    }

    method stop-sync-with proc {XnNodeHandle other} XnStatus {
	return xnStopFrameSyncWith (instance->handle, other);
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
