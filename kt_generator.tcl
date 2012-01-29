# # ## ### ##### ######## #############
## Generator Base Class -> production

critcl::class def kinetcl::Generator {
    # # ## ### ##### ######## #############
    ::kt_abstract_class {
    } {
    }

    # # ## ### ##### ######## #############
    ## Control and query data generation

    mdef start { /* Syntax: <instance> start */
	XnStatus s;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnStartGenerating (instance->handle);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef stop { /* Syntax: <instance> stop */
	XnStatus s;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnStopGenerating (instance->handle);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef active { /* Syntax: <instance> active */
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewIntObj (xnIsGenerating (instance->handle)));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    ## Wait for data, check if waiting would not block

    mdef wait { /* Syntax: <instance> wait */
	XnStatus s;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnWaitAndUpdateData (instance->handle);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef hasNew { /* Syntax: <instance> new */
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	/* XXX FUTURE: May pull and return timestamp of such new data */
	Tcl_SetObjResult (interp, Tcl_NewIntObj (xnIsNewDataAvailable (instance->handle, NULL)));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    ## Query data attributes (is it new?, frame id, timestamp)
    ## Note: Data size and data itself are not accessible here, but only is derived classes.

    mdef isNew { /* Syntax: <instance> new */
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewIntObj (xnIsDataNew (instance->handle)));
	return TCL_OK;
    }

    mdef frame { /* Syntax: <instance> frame */
	XnUInt32 frame;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	frame = xnGetFrameID (instance->handle);
	if (frame == ((XnUInt32) -1)) {
	    Tcl_AppendResult (interp, "Inheritance error: Not a generator", NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewIntObj (frame));
	return TCL_OK;
    }

    mdef time { /* Syntax: <instance> time */
	XnUInt64 timestamp;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	timestamp = xnGetTimestamp (instance->handle);
	if (timestamp == ((XnUInt64) -1)) {
	    Tcl_AppendResult (interp, "Inheritance error: Not a generator", NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewWideIntObj (timestamp));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    ## Callbacks: activity change, data update

    ::kt_callback active \
	xnRegisterToGenerationRunningChange \
	xnUnregisterFromGenerationRunningChange \
	{} {}

    ::kt_callback newdata \
	xnRegisterToNewDataAvailable \
	xnUnregisterFromNewDataAvailable \
	{} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
