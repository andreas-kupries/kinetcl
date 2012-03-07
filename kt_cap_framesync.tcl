# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapFramesync {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # XXX TODO Implement the API.

    # # ## ### ##### ######## #############

    # # ## ### ##### ######## #############

    # # ## ### ##### ######## #############

    kt_callback framesync \
	xnRegisterToFrameSyncChange \
	xnUnregisterFromFrameSyncChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
if 0 {
    # Support requires ability to determine if a Tcl_Obj* holds a node
    # object command (name), and to convert from that to an instnce
    # handle.

    # See alt.view as well.

    XnBool   xnCanFrameSyncWith (XnNodeHandle hInstance, XnNodeHandle hOther)
    XnStatus xnFrameSyncWith (XnNodeHandle hInstance, XnNodeHandle hOther)
    XnStatus xnStopFrameSyncWith (XnNodeHandle hInstance, XnNodeHandle hOther)
    XnBool   xnIsFrameSyncedWith (XnNodeHandle hInstance, XnNodeHandle hOther)
}
