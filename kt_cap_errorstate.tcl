# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapErrorState {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method error-state proc {} ok {
	XnStatus s;

	s = xnGetNodeErrorState (instance->handle);
	Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    kt_callback errorstate \
	xnRegisterToNodeErrorStateChange \
	xnUnregisterFromNodeErrorStateChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
