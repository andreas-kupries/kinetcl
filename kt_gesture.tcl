
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

    method add-gesture {gesture ?box?} {
	XnBoundingBox3D box;
	XnBoundingBox3D* thebox;
	XnStatus s;
	int lc;
	Tcl_Obj** lv;

	if ((objc < 3) || (objc > 4)) {
	    Tcl_WrongNumArgs (interp, 2, objv, "gesture ?box?");
	    return TCL_ERROR;
	}

	if (objc == 4) {
	    if (Tcl_ListObjGetElements (interp, objv[3], &lc, &lv) != TCL_OK) {
		return TCL_ERROR;
	    } else if (lc != 2) {
		Tcl_AppendResult (interp, "Expected box (2 points)", NULL);
		return TCL_ERROR;
	    }

	    if (kinetcl_convert_to3d (interp, lv [0], &box.LeftBottomNear) != TCL_OK) {
		return TCL_ERROR;
	    }

	    if (kinetcl_convert_to3d (interp, lv [1], &box.RightTopFar) != TCL_OK) {
		return TCL_ERROR;
	    }

	    thebox = &box;
	} else {
	    thebox = NULL;
	}

	s = xnAddGesture (instance->handle, Tcl_GetString (objv [2]), thebox);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method remove-gesture {gesture} {
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "gesture");
	    return TCL_ERROR;
	}

	s = xnRemoveGesture (instance->handle, Tcl_GetString (objv [2]));
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }


    method is-gesture {gesture} {
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

    method gesture-has-progress {gesture} {
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

    method all-gestures {} {
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

    method active-gestures {} {
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
	    CB_DETAIL ("gesture",      Tcl_NewStringObj (strGesture,-1));
	    CB_DETAIL ("id_position",  kinetcl_convert_3d (pIDPosition));
	    CB_DETAIL ("end_position", kinetcl_convert_3d (pEndPosition));
	} \
	gesture-progress {
	    {const XnChar*    strGesture}
	    {const XnPoint3D* pPosition}
	    {XnFloat          fProgress}
	} {
	    CB_DETAIL ("gesture",  Tcl_NewStringObj (strGesture,-1));
	    CB_DETAIL ("position", kinetcl_convert_3d (pPosition));
	    CB_DETAIL ("progress", Tcl_NewDoubleObj (fProgress));
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
	    CB_DETAIL ("gesture",  Tcl_NewStringObj (strGesture,-1));
	    CB_DETAIL ("position", kinetcl_convert_3d (pPosition));
	}

    ::kt_callback gesture-stage-ready-for-next \
	xnRegisterToGestureReadyForNextIntermediateStage \
	xnUnregisterFromGestureReadyForNextIntermediateStage \
	{
	    {const XnChar*    strGesture}
	    {const XnPoint3D* pPosition}
	} {
	    CB_DETAIL ("gesture",  Tcl_NewStringObj (strGesture,-1));
	    CB_DETAIL ("position", kinetcl_convert_3d (pPosition));
	}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
