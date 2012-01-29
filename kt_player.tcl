
# # ## ### ##### ######## #############
## Player

critcl::class def kinetcl::Player {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain player object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreatePlayer (instance->onicontext, "oni", &h);
    }

    # # ## ### ##### ######## #############
    mdef speed { /* Syntax: <instance> speed ?speed? */
	XnStatus s;
	double speed;

	if (objc == 2) { /* Syntax: <instance> speed */
	    speed = xnGetPlaybackSpeed (instance->handle);
	    Tcl_SetObjResult (interp, Tcl_NewDoubleObj (speed));
	    return TCL_OK;
	}

	if (objc == 3) { /* Syntax: <instance> speed <n> */
	    if (Tcl_GetDoubleFromObj (interp, objv [2], &speed) != TCL_OK) {
		return TCL_ERROR;
	    }

	    s = xnSetPlaybackSpeed  (instance->handle, speed);
	    CHECK_STATUS_RETURN;

	    return TCL_OK;
	}

	Tcl_WrongNumArgs (interp, 2, objv, "?speed?");
	return TCL_ERROR;
    }

    mdef repeat { /* Syntax: <instance> repeat bool */
	XnStatus s;
	int repeat;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	if (Tcl_GetBooleanFromObj (interp, objv [2], &repeat) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetPlayerRepeat (instance->handle, repeat);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef eof { /* Syntax: <instance> eof */
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewIntObj (xnIsPlayerAtEOF (instance->handle)));
	return TCL_OK;
    }

    mdef format { /* Syntax: <instance> format */
	Tcl_Obj* format;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	format = Tcl_NewStringObj (xnGetPlayerSupportedFormat (instance->handle), -1);
	Tcl_SetObjResult (interp, format);
	return TCL_OK;
    }

    mdef next { /* Syntax: <instance> next */
	XnStatus s;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnPlayerReadNext (instance->handle);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    # XXX enumerate player nodes
    # XXX seek, tell, query frames - player nodes needed.
    # XXX source

    # # ## ### ##### ######## #############
    ## Callbacks: @eof

    ::kt_callback eof \
	xnRegisterToEndOfFileReached \
	xnUnregisterFromEndOfFileReached \
	{} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
