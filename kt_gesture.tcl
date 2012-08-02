
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

    method @add-gesture1 proc {char* gesture} XnStatus {
	return xnAddGesture (instance->handle, gesture, NULL);
    }

    # TODO: cproc reference argument types.
    method @add-gesture2 proc {char* gesture XnBoundingBox box} XnStatus {
	return xnAddGesture (instance->handle, gesture, &box);
    }

    method remove-gesture proc {char* gesture} XnStatus {
	return xnRemoveGesture (instance->handle, gesture);
    }

    method is-gesture proc {char* gesture} XnStatus {
	return xnIsGestureAvailable (instance->handle, gesture);
    }

    method gesture-has-progress proc {char* gesture} XnStatus {
	return xnIsGestureProgressSupported (instance->handle, gesture);
    }

    method all-gestures proc {} ok {
	int i, res = TCL_OK;
	XnUInt16  n;
	XnChar** gesture;
	XnStatus  s;
	Tcl_Obj*  glist;

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

    method active-gestures proc {} ok {
	int i, res = TCL_OK;
	XnUInt16  n;
	XnChar** gesture;
	XnStatus  s;
	Tcl_Obj*  glist;

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
