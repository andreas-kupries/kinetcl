# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapUserSkeleton {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method need-pose proc {} bool {
	return xnNeedPoseForSkeletonCalibration (instance->handle);
    }

    # XXX Bogosity
    # XXX    XnStatus xnGetSkeletonCalibrationPose (XnNodeHandle HI, XnChar *strPose)
    # _get_ the pose, but 'strPose' is marked as input parameter, and
    # we do not know the length we would have pre-allocate either,
    # should the library try to fill the string.

    method is-profile-available proc {Tcl_Obj* profile} ok {
	int available, id;

	if (Tcl_GetIndexFromObj (interp, profile, 
				 @stem@_skeleton_profile,
				 "profile", 0, &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	available = xnIsProfileAvailable (instance->handle, id+1);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (available));
	return TCL_OK;
    }

    method available-profiles proc {} ok {
	int available, profile, pc;
	Tcl_Obj* pv [5];

	for (profile = XN_SKEL_PROFILE_NONE, pc = 0;
	     profile <= XN_SKEL_PROFILE_HEAD_HANDS;
	     profile++) {
	    available = xnIsProfileAvailable (instance->handle, profile);
	    if (!available) continue;
	    pv [pc] = Tcl_NewStringObj (@stem@_skeleton_profile [profile-1],-1);
	    pc ++;
	}

	Tcl_SetObjResult (interp, Tcl_NewListObj (pc, pv));
	return TCL_OK;
    }

    method all-profiles proc {} ok {
	int available, profile, pc;
	Tcl_Obj* pv [5];

	for (profile = XN_SKEL_PROFILE_NONE, pc = 0;
	     profile <= XN_SKEL_PROFILE_HEAD_HANDS;
	     profile++) {
	    pv [pc] = Tcl_NewStringObj (@stem@_skeleton_profile [profile-1],-1);
	    pc ++;
	}

	Tcl_SetObjResult (interp, Tcl_NewListObj (pc, pv));
	return TCL_OK;
    }

    method set-profile proc {Tcl_Obj* profile} ok {
	int id;
	XnStatus s;

	if (Tcl_GetIndexFromObj (interp, profile, 
				 @stem@_skeleton_profile,
				 "profile", 0, &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetSkeletonProfile (instance->handle, id+1);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method set-smoothing proc {double factor} ok {
	XnStatus s;

	s = xnSetSkeletonSmoothing (instance->handle, factor);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method start-tracking proc {int id} ok {
	XnStatus s;

	s = xnStartSkeletonTracking (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method stop-tracking proc {int id} ok {
	XnStatus s;

	s = xnStopSkeletonTracking (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method reset-tracking proc {int id} ok {
	XnStatus s;

	s = xnResetSkeleton (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method is-tracking proc {int id} bool {
	return xnIsSkeletonTracking (instance->handle, id);
    }

    method is-calibrated proc {int id} bool {
	return xnIsSkeletonCalibrated (instance->handle, id);
    }

    method is-calibrating proc {int id} bool {
	return xnIsSkeletonCalibrating (instance->handle, id);
    }

    method request-calibration proc {int id bool force} ok {
	XnStatus s;

	s = xnRequestSkeletonCalibration (instance->handle, id, force);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method abort-calibration proc {int id} ok {
	XnStatus s;

	s = xnAbortSkeletonCalibration (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    # XXX The higher level wrapper handles vfs, by routing through a
    # XXX temp file when needed.

    method save-calibration-file proc {int id char* path} ok {
	XnStatus s;

	s = xnSaveSkeletonCalibrationDataToFile (instance->handle, id, path);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method load-calibration-file proc {int id char* path} ok {
	XnStatus s;

	s = xnLoadSkeletonCalibrationDataFromFile (instance->handle, id, path);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method save-calibration-slot proc {int id int slot} ok {
	XnStatus s;

	s = xnSaveSkeletonCalibrationData (instance->handle, id, slot);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method load-calibration-slot proc {int id int slot} ok {
	XnStatus s;

	s = xnLoadSkeletonCalibrationData (instance->handle, id, slot);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method clear-calibration-slot proc {int slot} ok {
	XnStatus s;

	s = xnClearSkeletonCalibrationData (instance->handle, slot);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method is-calibration-slot proc {int slot} bool {
	return xnClearSkeletonCalibrationData (instance->handle, slot);
    }

    method is-joint-available proc {Tcl_Obj* joint} ok {
	int available, jointid;

	if (Tcl_GetIndexFromObj (interp, joint, 
				 @stem@_skeleton_joint,
				 "joint", 0, &jointid) != TCL_OK) {
	    return TCL_ERROR;
	}

	available = xnIsJointAvailable (instance->handle, jointid+1);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (available));
	return TCL_OK;
    }

    method is-joint-active proc {Tcl_Obj* joint} ok {
	int active, jointid;

	if (Tcl_GetIndexFromObj (interp, joint, 
				 @stem@_skeleton_joint,
				 "joint", 0, &jointid) != TCL_OK) {
	    return TCL_ERROR;
	}

	active = xnIsJointActive (instance->handle, jointid+1);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (active));
	return TCL_OK;
    }

    method set-joint-active proc {Tcl_Obj* joint bool active} ok {
	int jointid;
	XnStatus s;

	if (Tcl_GetIndexFromObj (interp, joint, 
				 @stem@_skeleton_joint,
				 "joint", 0, &jointid) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetJointActive (instance->handle, jointid+1, active);
	CHECK_STATUS_RETURN;

	Tcl_SetObjResult (interp, Tcl_NewIntObj (active));
	return TCL_OK;
    }

    method active-joints proc {} ok {
	XnStatus s;
	XnUInt16 n;
	XnSkeletonJoint j [XN_SKEL_RIGHT_FOOT+1];
	Tcl_Obj*       jn [XN_SKEL_RIGHT_FOOT+1];
	int k;

	n = XN_SKEL_RIGHT_FOOT+1;
	s = xnEnumerateActiveJoints (instance->handle, j, &n);
	CHECK_STATUS_RETURN;

	for (k=0; k < n; k++) {
            jn [k] = Tcl_NewStringObj (@stem@_skeleton_joint [j[k]-1],-1);
	}

	Tcl_SetObjResult (interp, Tcl_NewListObj (n, jn));
	return TCL_OK;
    }

    method get-joint proc {int userid Tcl_Obj* joint} ok {
	Tcl_Obj* result;
	int jointid;

	if (Tcl_GetIndexFromObj (interp, joint, 
				 @stem@_skeleton_joint,
				 "joint", 0, &jointid) != TCL_OK) {
	    return TCL_ERROR;
	}

	result = @stem@_get_joint (interp, instance, userid, jointid);
	if (!result) {
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, result);
	return TCL_OK;
    }

    method get-skeleton proc {int userid} ok {
	Tcl_Obj* result;

	result = @stem@_get_skeleton (interp, instance, userid);
	if (!result) {
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, result);
	return TCL_OK;
    }

    # Partial joint information.
    # XnStatus xnGetSkeletonJointPosition    (XnNodeHandle HI, XnUserID user,
    #                                         XnSkeletonJoint eJoint,
    #                                         XnSkeletonJointPosition *pJoint)
    # XnStatus xnGetSkeletonJointOrientation (XnNodeHandle HI, XnUserID user,
    #                                         XnSkeletonJoint eJoint,
    #                                         XnSkeletonJointOrientation *pJoint)

    # # ## ### ##### ######## #############

    support {
	static const char* @stem@_skeleton_joint [] = {
	    "head",		/* XN_SKEL_HEAD */
	    "neck",		/* XN_SKEL_NECK */
	    "torso",		/* XN_SKEL_TORSO */
	    "waist",		/* XN_SKEL_WAIST */
	    "left-collar",	/* XN_SKEL_LEFT_COLLAR */
	    "left-shoulder",	/* XN_SKEL_LEFT_SHOULDER */
	    "left-elbow",	/* XN_SKEL_LEFT_ELBOW */
	    "left-wrist",	/* XN_SKEL_LEFT_WRIST */
	    "left-hand",	/* XN_SKEL_LEFT_HAND */
	    "left-fingertip",	/* XN_SKEL_LEFT_FINGERTIP */
	    "right-collar",	/* XN_SKEL_RIGHT_COLLAR */
	    "right-shoulder",	/* XN_SKEL_RIGHT_SHOULDER */
	    "right-elbow",	/* XN_SKEL_RIGHT_ELBOW */
	    "right-wrist",	/* XN_SKEL_RIGHT_WRIST */
	    "right-hand",	/* XN_SKEL_RIGHT_HAND */
	    "right-fingertip",	/* XN_SKEL_RIGHT_FINGERTIP */
	    "left-hip",		/* XN_SKEL_LEFT_HIP */
	    "left-knee",	/* XN_SKEL_LEFT_KNEE */
	    "left-ankle",	/* XN_SKEL_LEFT_ANKLE */
	    "left-foot",	/* XN_SKEL_LEFT_FOOT */
	    "right-hip",	/* XN_SKEL_RIGHT_HIP */
	    "right-knee",	/* XN_SKEL_RIGHT_KNEE */
	    "right-ankle",	/* XN_SKEL_RIGHT_ANKLE */
	    "right-foot",	/* XN_SKEL_RIGHT_FOOT */
	    NULL
	};

	static const char* @stem@_skeleton_profile [] = {
	    "none",		/* XN_SKEL_PROFILE_NONE */
	    "all",		/* XN_SKEL_PROFILE_ALL */
	    "upper",		/* XN_SKEL_PROFILE_UPPER */
	    "lower",		/* XN_SKEL_PROFILE_LOWER */
	    "heads-hands",	/* XN_SKEL_PROFILE_HEAD_HANDS */
	    NULL
	};

	static const char* @stem@_skeleton_calibration [] = {
	    "ok",		/* XN_CALIBRATION_STATUS_OK */
	    "no-user",		/* XN_CALIBRATION_STATUS_NO_USER */
	    "arm",		/* XN_CALIBRATION_STATUS_ARM */
	    "leg",		/* XN_CALIBRATION_STATUS_LEG */
	    "head",		/* XN_CALIBRATION_STATUS_HEAD */
	    "torso",		/* XN_CALIBRATION_STATUS_TORSO */
	    "top-fov",		/* XN_CALIBRATION_STATUS_TOP_FOV */
	    "side-fov",		/* XN_CALIBRATION_STATUS_SIDE_FOV */
	    "pose",		/* XN_CALIBRATION_STATUS_POSE */
	    "manual-abort",	/* XN_CALIBRATION_STATUS_MANUAL_ABORT */
	    "manual-reset",	/* XN_CALIBRATION_STATUS_MANUAL_RESET */
	    "timeout",		/* XN_CALIBRATION_STATUS_TIMEOUT_FAIL */
	    NULL
	};

	static Tcl_Obj*
	@stem@_get_joint (Tcl_Interp* interp,
			  @instancetype@ instance,
			  int userid,
			  int joint)
	{
	    int k;
	    XnStatus s;
	    XnSkeletonJointTransformation t;
	    Tcl_Obj* matrix [9];
	    Tcl_Obj* pos [2];
	    Tcl_Obj* ori [2];
	    Tcl_Obj* result [2];

	    s = xnGetSkeletonJoint (instance->handle, userid, joint+1, &t);
	    CHECK_STATUS_RETURN_NULL;

	    /* t.position.position       3D  */
	    /* t.position.fConfidence        */
	    /* t.orientation.orientation [9] */
	    /* t.orientation.fConfidence     */

	    pos [0] = Tcl_NewDoubleObj (t.position.fConfidence);
	    pos [1] = kinetcl_convert_3d (&t.position.position);

	    for (k = 0; k < 9; k++) {
	        matrix [k] = Tcl_NewDoubleObj (t.orientation.orientation.elements [k]);
	    }

	    ori [0] = Tcl_NewDoubleObj (t.orientation.fConfidence);
	    ori [1] = Tcl_NewListObj (9, matrix);

	    result [0] = Tcl_NewListObj (2, pos);
	    result [1] = Tcl_NewListObj (2, ori);

	    return Tcl_NewListObj (2, result);
	}

	static Tcl_Obj*
	@stem@_get_skeleton (Tcl_Interp* interp,
			     @instancetype@ instance,
			     int userid)
	{
	    Tcl_Obj* jres;
	    Tcl_Obj* res = Tcl_NewDictObj ();
	    int joint;

	    for (joint = 0; joint < XN_SKEL_RIGHT_FOOT; joint ++)
	    {
	        if (!xnIsJointAvailable (instance->handle, joint+1)) continue;
		if (!xnIsJointActive    (instance->handle, joint+1)) continue;

	        jres = @stem@_get_joint (interp, instance, userid, joint);
		if (!jres) goto error;
		Tcl_DictObjPut (interp, res,
				Tcl_NewStringObj (@stem@_skeleton_joint[joint],-1),
				jres);
	    }

	    return res;
        error:
	    Tcl_DecrRefCount (res);
	    return 0;
	}
    }

    # # ## ### ##### ######## #############
    ## Callbacks, joint configuration changes, calibration process events

    ::kt_callback joint \
	xnRegisterToJointConfigurationChange \
	xnUnregisterFromJointConfigurationChange \
	{} {}

    ::kt_callback calibration-start \
	xnRegisterToCalibrationStart \
	xnUnregisterFromCalibrationStart \
	{{XnUserID user}} {
	    CB_DETAIL ("user", Tcl_NewIntObj (user));
	}

    ::kt_callback calibration-complete \
	xnRegisterToCalibrationComplete \
	xnUnregisterFromCalibrationComplete \
	{
	    {XnUserID            user}
	    {XnCalibrationStatus cStatus}
	} {
	    CB_DETAIL ("user",   Tcl_NewIntObj (user));
	    CB_DETAIL ("status", Tcl_NewStringObj (@stem@_skeleton_calibration [cStatus],-1));
	}

    ::kt_callback calibration-progress \
	xnRegisterToCalibrationInProgress \
	xnUnregisterFromCalibrationInProgress \
	{
	    {XnUserID            user}
	    {XnCalibrationStatus cStatus}
	} {
	    CB_DETAIL ("user",   Tcl_NewIntObj (user));
	    CB_DETAIL ("status", Tcl_NewStringObj (@stem@_skeleton_calibration [cStatus],-1));
	}

    # NOTE
    # xnRegisterCalibrationCallbacks   | Deprecated in favor of the above calibration
    # xnUnregisterCalibrationCallbacks | start, progress, and complete callbacks.

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
