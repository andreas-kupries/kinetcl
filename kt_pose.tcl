# # ## ### ##### ######## #############
## Capability Class

critcl::class def kinetcl::CapUserPoseDetection {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    mdef is-supported { /* Syntax: <instance> isSupported <pose> */
	int supported;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "pose");
	    return TCL_ERROR;
	}

	supported = xnIsPoseSupported (instance->handle,
				       Tcl_GetString (objv[3]));

	Tcl_SetObjResult (interp, Tcl_NewIntObj (supported));
	return TCL_OK;
    }

    mdef poses { /* Syntax: <instance> poses */
	XnStatus s;
	int lc;
	Tcl_Obj** lv = NULL;
	XnChar** poses;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	lc = xnGetNumberOfPoses (instance->handle);
	if (lc) {
	    int i;

	    poses = (XnChar**) ckalloc (lc * sizeof (XnChar*));
	    s = xnGetAvailablePoses (instance->handle, poses, &lc);
	    CHECK_STATUS_GOTO;

	    for (i = 0;
		 i < lc;
		 i++) {
	       lv [i] = Tcl_NewStringObj (poses [i],-1);
	    }

	    ckfree ((char*) poses);
	}

	Tcl_SetObjResult (interp, Tcl_NewListObj (lc, lv));

	if (lc) {
	    ckfree ((char*) lv);
	}

	return TCL_OK;
error:
	ckfree ((char*) poses);
	return TCL_ERROR;
    }

    mdef start-detection { /* Syntax: <instance> startDetection <id> <pose> */
	int id;
	XnStatus s;

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "user pose");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnStartPoseDetection (instance->handle,
				  Tcl_GetString (objv[3]), id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef stop-detection { /* Syntax: <instance> stopDetection <id> <pose> */
	int id;
	XnStatus s;

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "user pose");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnStopSinglePoseDetection (instance->handle, id,
				       Tcl_GetString (objv[3]));
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef stop-all-detection { /* Syntax: <instance> stopDetection <id> */
	int id;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "user");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnStopPoseDetection (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef status { /* Syntax: <instance> status <id> <pose> */
	int id;
	XnStatus s;
	XnUInt64 timestamp;
	XnPoseDetectionStatus pstatus;
	XnPoseDetectionState  pstate;
	Tcl_Obj* pv [3];

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "user pose");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnGetPoseStatus (instance->handle, id, 
			     Tcl_GetString (objv[3]),
			     &timestamp, &pstatus, &pstate);
	CHECK_STATUS_RETURN;

	pv [0] = Tcl_NewStringObj (@stem@_pose_detection_state  [pstate],-1);
	pv [1] = Tcl_NewStringObj (@stem@_pose_detection_status [pstatus],-1);
	pv [2] = Tcl_NewWideIntObj (timestamp);
	Tcl_SetObjResult (interp, Tcl_NewListObj (3, pv));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    support {
	const char*
	@stem@_pose_detection_status [] = {
	    "ok",		/* XN_POSE_DETECTION_STATUS_OK */
	    "no-user",		/* XN_POSE_DETECTION_STATUS_NO_USER */
	    "top-fov",		/* XN_POSE_DETECTION_STATUS_TOP_FOV */
	    "side-fov",		/* XN_POSE_DETECTION_STATUS_SIDE_FOV */
	    "error",		/* XN_POSE_DETECTION_STATUS_ERROR */
	    "no-tracking",	/* XN_POSE_DETECTION_STATUS_NO_TRACKING */
	    NULL
	};

	const char*
	@stem@_pose_detection_state [] = {
	    "in",		/* XN_POSE_DETECTION_STATE_IN_POSE */
	    "out",		/* XN_POSE_DETECTION_STATE_OUT_OF_POSE */
	    "undefined",	/* XN_POSE_DETECTION_STATE_UNDEFINED */
	    NULL
	};
    }

    # # ## ### ##### ######## #############

    ::kt_callback poseEnter \
	xnRegisterToPoseDetected \
	xnUnregisterFromPoseDetected \
	{
	    {const XnChar *strPose}
	    {XnUserID u}
	} {
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (strPose,-1));
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewIntObj (u));
	}

    ::kt_callback poseExit \
	xnRegisterToOutOfPose \
	xnUnregisterFromOutOfPose \
	{
	    {const XnChar *strPose}
	    {XnUserID u}
	} {
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (strPose,-1));
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewIntObj (u));
	}

    ::kt_callback poseProgress \
	xnRegisterToPoseDetectionInProgress \
	xnUnregisterFromPoseDetectionInProgress \
	{
	    {const XnChar *strPose}
	    {XnUserID u}
	    {XnPoseDetectionStatus pstatus}
	} {
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (strPose,-1));
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewIntObj (u));
	    Tcl_ListObjAppendElement (interp, cmd,
				      Tcl_NewStringObj (@stem@_pose_detection_status [pstatus],
							-1));
	}

    # NOTE
    # xnRegisterToPoseCallbacks     | The 1:2 callbacks are deprecated in favor of the
    # xnUnregisterFromPoseCallbacks | saeparate callbacks above (enter, exit, progress).

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
