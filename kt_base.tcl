# # ## ### ##### ######## #############
## Base Class

critcl::class def kinetcl::Base {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############
    mdef isCapableOf {
	XnBool supported;
	char* capName;

	/* Syntax: isCapableOf capName */
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	capName = NULL; /* XXX */

	supported = xnIsCapabilitySupported (instance->handle, capName);
	Tcl_SetObjResult (interp, Tcl_NewIntObj (supported));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
