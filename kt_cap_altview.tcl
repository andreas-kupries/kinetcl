# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapAlternativeViewpoint {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # XXX TODO Implement the API.

    # # ## ### ##### ######## #############

    # # ## ### ##### ######## #############

    # # ## ### ##### ######## #############

    kt_callback viewpoint \
	xnRegisterToViewPointChange \
	xnUnregisterFromViewPointChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
if 0 {
    # Support requires ability to determine if a Tcl_Obj* holds a node
    # object command (name), and to convert from that to an instnce
    # handle.

    # See framesync as well.

    XnBool   xnIsViewPointSupported (XnNodeHandle hInstance, XnNodeHandle hOther)
    XnStatus xnSetViewPoint         (XnNodeHandle hInstance, XnNodeHandle hOther)
    XnStatus xnResetViewPoint       (XnNodeHandle hInstance)
    XnBool   xnIsViewPointAs        (XnNodeHandle hInstance, XnNodeHandle hOther)
}
