# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapErrorState {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    mdef error-state { /* Syntax: <instance> error-state */
	XnStatus s;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnGetNodeErrorState (instance->handle);
	Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    kt_callback errorstate \
	xnRegisterToErrorStateChange \
	xnUnregisterFromErrorStateChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
