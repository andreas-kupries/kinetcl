
# # ## ### ##### ######## #############
## Gesture Generator

critcl::class def ::kinetcl::Gesture {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain gesture generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateGestureGenerator (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############

    mdef add-gesture { /* Syntax: <instance> add-gesture <str> <box> */
	XnBoundingBox3D box;
	XnStatus s;
	int lc;
	Tcl_Obj** lv;
	int lbnc;
	Tcl_Obj** lbnv;
	int rtfc;
	Tcl_Obj** rtfv;
	double lbn_x, lbn_y, lbn_z;
	double rtf_x, rtf_y, rtf_z;

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "gesture box");
	    return TCL_ERROR;
	}

	if (Tcl_ListObjGetElements (interp, objv[3], &lc, &lv) != TCL_OK) {
	    return TCL_ERROR;
	} else if (lc != 2) {
	    Tcl_AppendResult (interp, "Expected box (2 points)", NULL);
	    return TCL_ERROR;
	}

	if (Tcl_ListObjGetElements (interp, lv[0], &lbnc, &lbnv) != TCL_OK) {
	    return TCL_ERROR;
	} else if (lbnc != 3) {
	    Tcl_AppendResult (interp, "Expected 3 coordinates in left bottom near point", NULL);
	    return TCL_ERROR;
	}

	if (Tcl_ListObjGetElements (interp, lv[1], &rtfc, &rtfv) != TCL_OK) {
	    return TCL_ERROR;
	} else if (rtfc != 3) {
	    Tcl_AppendResult (interp, "Expected 3 coordinates in right top far point", NULL);
	    return TCL_ERROR;
	}

	if (Tcl_GetDoubleFromObj (interp, lbnv[0], &lbn_x) != TCL_OK) {
	    return TCL_ERROR;
	}
	if (Tcl_GetDoubleFromObj (interp, lbnv[1], &lbn_y) != TCL_OK) {
	    return TCL_ERROR;
	}
	if (Tcl_GetDoubleFromObj (interp, lbnv[2], &lbn_z) != TCL_OK) {
	    return TCL_ERROR;
	}

	if (Tcl_GetDoubleFromObj (interp, rtfv[0], &rtf_x) != TCL_OK) {
	    return TCL_ERROR;
	}
	if (Tcl_GetDoubleFromObj (interp, rtfv[1], &rtf_y) != TCL_OK) {
	    return TCL_ERROR;
	}
	if (Tcl_GetDoubleFromObj (interp, rtfv[2], &rtf_z) != TCL_OK) {
	    return TCL_ERROR;
	}

	box.LeftBottomNear.X = lbn_x;
	box.LeftBottomNear.Y = lbn_y;
	box.LeftBottomNear.Z = lbn_z;
	box.RightTopFar.X    = rtf_x;
	box.RightTopFar.Y    = rtf_y;
	box.RightTopFar.Z    = rtf_z;

	s = xnAddGesture (instance->handle, Tcl_GetString (objv [2]), &box);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef remove-gesture { /* Syntax: <instance> remove-gesture <str> */
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "gesture");
	    return TCL_ERROR;
	}

	s = xnRemoveGesture (instance->handle, Tcl_GetString (objv [2]));
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }


    mdef is-gesture { /* Syntax: <instance> is-gesture <str> */
	int id;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "gesture");
	    return TCL_ERROR;
	}

	s = xnIsGestureAvailable (instance->handle, Tcl_GetString (objv [2]));
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef gesture-has-progress { /* Syntax: <instance> gesture-has-progress <str> */
	int id;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "gesture");
	    return TCL_ERROR;
	}

	s = xnIsGestureProgressSupported (instance->handle, Tcl_GetString (objv [2]));
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef all-gestures { /* Syntax: <instance> all-gestures */
	int i, res = TCL_OK;
	XnUInt16  n;
	XnChar** gesture;
	XnStatus  s;
	Tcl_Obj*  glist;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	n = xnGetNumberOfAvailableGestures (instance->handle);
	gesture = (XnChar**) ckalloc (n * sizeof (XnChar*));

	for (i=0; i < n; i++) {
            /* Pray that this is enough space per gesture name.
	     */
	    gesture [i] = ckalloc (50);
	}

	s = xnEnumerateAllGestures (instance->handle, gesture, 50, &n);
	CHECK_STATUS_GOTO;

	glist = Tcl_NewListObj (0,NULL);
	for (i=0; i < n; i++) {
            if (Tcl_ListObjAppendElement (interp, glist, Tcl_NewStringObj (gesture [i],-1)) != TCL_OK) {
		Tcl_DecrRefCount (glist);
		goto error;
	    }
	}

	Tcl_SetObjResult (interp, glist);
	goto done;

      error:
	res = TCL_ERROR;
      done:
	for (i=0; i < n; i++) { ckfree (gesture [i]); }
	ckfree ((char*) gesture);
	return res;
    }

    mdef active-gestures { /* Syntax: <instance> active-gestures */
	int i, res = TCL_OK;
	XnUInt16  n;
	XnChar** gesture;
	XnStatus  s;
	Tcl_Obj*  glist;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	n = xnGetNumberOfAvailableGestures (instance->handle);
	gesture = (XnChar**) ckalloc (n * sizeof (XnChar*));

	for (i=0; i < n; i++) {
            /* Pray that this is enough space per gesture name.
	     */
	    gesture [i] = ckalloc (50);
	}

	s = xnGetAllActiveGestures (instance->handle, gesture, 50, &n);
	CHECK_STATUS_GOTO;

	glist = Tcl_NewListObj (0,NULL);
	for (i=0; i < n; i++) {
            if (Tcl_ListObjAppendElement (interp, glist, Tcl_NewStringObj (gesture [i],-1)) != TCL_OK) {
		Tcl_DecrRefCount (glist);
		goto error;
	    }
	}

	Tcl_SetObjResult (interp, glist);
	goto done;

      error:
	res = TCL_ERROR;
      done:
	for (i=0; i < n; i++) { ckfree (gesture [i]); }
	ckfree ((char*) gesture);
	return res;
    }


    # # ## ### ##### ######## #############
    # # ## ### ##### ######## #############

    ::kt_2callback gesture \
	xnRegisterGestureCallbacks \
	xnUnregisterGestureCallbacks \
	gesture-recognized {
	    {const XnChar*    strGesture}
	    {const XnPoint3D* pIDPosition}
	    {const XnPoint3D* pEndPosition}
	} {
	    Tcl_Obj* coord [3];

	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (strGesture,-1));

	    coord [0] = Tcl_NewDoubleObj (pIDPosition->X);
	    coord [1] = Tcl_NewDoubleObj (pIDPosition->Y);
	    coord [2] = Tcl_NewDoubleObj (pIDPosition->Z);
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3,coord));

	    coord [0] = Tcl_NewDoubleObj (pEndPosition->X);
	    coord [1] = Tcl_NewDoubleObj (pEndPosition->Y);
	    coord [2] = Tcl_NewDoubleObj (pEndPosition->Z);
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3,coord));
	} \
	gesture-progress {
	    {const XnChar*    strGesture}
	    {const XnPoint3D* pPosition}
	    {XnFloat          fProgress}
	} {
	    Tcl_Obj* coord [3];

	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (strGesture,-1));

	    coord [0] = Tcl_NewDoubleObj (pPosition->X);
	    coord [1] = Tcl_NewDoubleObj (pPosition->Y);
	    coord [2] = Tcl_NewDoubleObj (pPosition->Z);
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3,coord));

	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewDoubleObj (fProgress));
	}

    ::kt_callback gesture-change \
	xnRegisterToGestureChange \
	xnUnregisterFromGestureChange \
	{} {}

    ::kt_callback gesture-stage-complete \
	xnRegisterToGestureIntermediateStageCompleted \
	xnUnregisterFromGestureIntermediateStageCompleted \
	{
	    {const XnChar*    strGesture}
	    {const XnPoint3D* pPosition}
	} {
	    Tcl_Obj* coord [3];

	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (strGesture,-1));

	    coord [0] = Tcl_NewDoubleObj (pPosition->X);
	    coord [1] = Tcl_NewDoubleObj (pPosition->Y);
	    coord [2] = Tcl_NewDoubleObj (pPosition->Z);
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3,coord));
	}

    ::kt_callback gesture-stage-ready-for-next \
	xnRegisterToGestureReadyForNextIntermediateStage \
	xnUnregisterFromGestureReadyForNextIntermediateStage \
	{
	    {const XnChar*    strGesture}
	    {const XnPoint3D* pPosition}
	} {
	    Tcl_Obj* coord [3];

	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (strGesture,-1));

	    coord [0] = Tcl_NewDoubleObj (pPosition->X);
	    coord [1] = Tcl_NewDoubleObj (pPosition->Y);
	    coord [2] = Tcl_NewDoubleObj (pPosition->Z);
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3,coord));
	}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
