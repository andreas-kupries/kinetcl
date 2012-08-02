# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapAntiflicker {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############
    ## TODO: policy level classes for capabilities!

    method frequency command {objev[2] == ?f|off?} {
	if (objc == 2) { /* Syntax: <instance> frequency */
	    Tcl_Obj* res;
	    XnPowerLineFrequency f = xnGetPowerLineFrequency (instance->handle);

	    if (f == ((XnPowerLineFrequency) -1)) {
		Tcl_AppendResult (interp, "Antiflicker not supported", NULL);
		return TCL_ERROR;
	    }

	    if (!f) {
		res = Tcl_NewStringObj ("off",-1);
	    } else {
		res = Tcl_NewIntObj (f);
	    }

	    Tcl_SetObjResult (interp, res);
	    return TCL_OK;
	}

	if (objc == 3) { /* Syntax: <instance> frequency off|n */
	    XnStatus s;
	    int f;

	    if (0 == strcmp ("off", Tcl_GetString (objv [2]))) {
		f = 0;
	    } else if (Tcl_GetIntFromObj (interp, objv [2], &f) != TCL_OK) {
		return TCL_ERROR;
	    }
	    if (f && (f != 50) && (f != 60)) {
		char buf [20];
		sprintf (buf, "%d", f);
		Tcl_AppendResult (interp, "Bad frequency ", buf, ", expected 50, 60, or off", NULL);
		return TCL_ERROR;
	    }

	    s = xnSetPowerLineFrequency (instance->handle, f);
	    CHECK_STATUS_RETURN;

	    return TCL_OK;
	}

	Tcl_WrongNumArgs (interp, 2, objv, "?frequency|off?");
	return TCL_ERROR;
    }

    # # ## ### ##### ######## #############

    kt_callback frequency \
	xnRegisterToPowerLineFrequencyChange \
	xnUnregisterFromPowerLineFrequencyChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
