# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapUserPoseDetection {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method is-supported proc {char* pose} bool {
	return xnIsPoseSupported (instance->handle, pose);
    }

    method poses proc {} KTcl_Obj* {
	XnStatus s;
	int i, n, lc;
	Tcl_Obj** lv = NULL;
	Tcl_Obj* result = NULL;
	XnChar** poses;

	lc = xnGetNumberOfPoses (instance->handle);
	if (lc) {
	    poses = (XnChar**) ckalloc (lc * sizeof (XnChar*));
	    for (i=0; i < lc; i++) {
		/* Pray that this is enough space. This not about overwriting,
		 * we are using the limited call, but about truncation of
		 * long pose names
		 */
		poses [i] = ckalloc (50);
	    }

	    n = lc;
	    s = xnGetAllAvailablePoses (instance->handle, poses, 50, &lc);
	    CHECK_STATUS_GOTO;

	    lv = (Tcl_Obj**) ckalloc (lc * sizeof (Tcl_Obj*));
	    for (i = 0;
		 i < lc;
		 i++) {
	       lv [i] = Tcl_NewStringObj (poses [i],-1);
	    }

	    for (i=0; i < n; i++) {
	        ckfree (poses [i]);
	    }
	    ckfree ((char*) poses);
	}

	result = Tcl_NewListObj (lc, lv);

	if (lc) {
	    ckfree ((char*) lv);
	}

	return result;
error:
	for (i=0; i < n; i++) {
	    ckfree (poses [i]);
	}
	ckfree ((char*) poses);
	return 0;
    }

    method start-detection proc {int id char* pose} XnStatus {
	return xnStartPoseDetection (instance->handle, pose, id);
    }

    method stop-detection proc {int id char* pose} XnStatus {
	return xnStopSinglePoseDetection (instance->handle, id, pose);
    }

    method stop-all-detection proc {int id} XnStatus {
	return xnStopPoseDetection (instance->handle, id);
    }

    method status proc {int id char* pose} ok {
	XnStatus s;
	XnUInt64 timestamp;
	XnPoseDetectionStatus pstatus;
	XnPoseDetectionState  pstate;
	Tcl_Obj* pv [3];

	s = xnGetPoseStatus (instance->handle, id, pose,
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

    ::kt_callback pose-enter \
	xnRegisterToPoseDetected \
	xnUnregisterFromPoseDetected \
	{
	    {const XnChar* strPose}
	    {XnUserID u}
	} {
	    CB_DETAIL ("pose", Tcl_NewStringObj (strPose,-1));
	    CB_DETAIL ("user", Tcl_NewIntObj (u));
	}

    ::kt_callback pose-exit \
	xnRegisterToOutOfPose \
	xnUnregisterFromOutOfPose \
	{
	    {const XnChar* strPose}
	    {XnUserID u}
	} {
	    CB_DETAIL ("pose", Tcl_NewStringObj (strPose,-1));
	    CB_DETAIL ("user", Tcl_NewIntObj (u));
	}

    ::kt_callback pose-progress \
	xnRegisterToPoseDetectionInProgress \
	xnUnregisterFromPoseDetectionInProgress \
	{
	    {const XnChar* strPose}
	    {XnUserID u}
	    {XnPoseDetectionStatus pstatus}
	} {
	    CB_DETAIL ("pose",   Tcl_NewStringObj (strPose,-1));
	    CB_DETAIL ("user",   Tcl_NewIntObj (u));
	    CB_DETAIL ("status", Tcl_NewStringObj (@stem@_pose_detection_status [pstatus], -1));
	}

    # NOTE
    # xnRegisterToPoseCallbacks     | The 1:2 callbacks are deprecated in favor of the
    # xnUnregisterFromPoseCallbacks | separate callbacks above (enter, exit, progress).

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
