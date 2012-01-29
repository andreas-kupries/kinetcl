
# # ## ### ##### ######## #############
## User Generator

critcl::class def kinetcl::User {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain user generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateUserGenerator (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############
    mdef count {
	/* Syntax: count */
	if (objc != 1) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewIntObj (xnGetNumberOfUsers (instance->handle)));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    mdef users {
	/* Syntax: users */

	int i, res = TCL_OK;
	XnUInt16  n;
	XnUserID* id;
	XnStatus  s;
	Tcl_Obj*  ulist;

	if (objc != 1) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	n = xnGetNumberOfUsers (instance->handle);
	id = (XnUserID*) ckalloc (n * sizeof (XnUserID));

	s = xnGetUsers (instance->handle, id, &n);
	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	ulist = Tcl_NewListObj (0,NULL);
	for (i=0; i < n; i++) {
            if (Tcl_ListObjAppendElement (interp, ulist, Tcl_NewIntObj (id [i])) != TCL_OK) {
		Tcl_DecrRefCount (ulist);
		goto error;
	    }
	}

	Tcl_SetObjResult (interp, ulist);
	goto done;

      error:
	res = TCL_ERROR;
      done:
	ckfree ((char*) id);
	return res;
    }

    # # ## ### ##### ######## #############
    mdef centerof {
	/* Syntax: centerof <id> */
	int id;
	XnStatus s;
	XnPoint3D p;
	Tcl_Obj* coord [3];

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[1], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnGetUserCoM (instance->handle, id, &p);
	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    return TCL_ERROR;
	}

	coord [0] = Tcl_NewIntObj (p.X);
	coord [1] = Tcl_NewIntObj (p.Y);
	coord [2] = Tcl_NewIntObj (p.Z);
	Tcl_SetObjResult (interp, Tcl_NewListObj (3, coord));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    # mdef pixelsof {} : TODO - Requires CRIMP (image).

    # # ## ### ##### ######## #############
    ## Callbacks: enter, exit, new/lost

    ::kt_callback enter \
	xnRegisterToUserReEnter \
	xnUnregisterFromUserReEnter \
	{{XnUserID u}} {
	    Tcl_ListObjAppendElement (instance->interp, cmd, Tcl_NewIntObj (u));
	}

    ::kt_callback exit \
	xnRegisterToUserExit \
	xnUnregisterFromUserExit \
	{{XnUserID u}} {
	    Tcl_ListObjAppendElement (instance->interp, cmd, Tcl_NewIntObj (u));
	}

    ::kt_2callback newlost \
	xnRegisterUserCallbacks \
	xnUnregisterUserCallbacks \
	new {{XnUserID u}} {
	    Tcl_ListObjAppendElement (instance->interp, cmd, Tcl_NewIntObj (u));
	} \
	lost {{XnUserID u}} {
	    Tcl_ListObjAppendElement (instance->interp, cmd, Tcl_NewIntObj (u));
	}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
