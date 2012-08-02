# # ## ### ##### ######## #############
## Capability Class

# # ## ### ##### ######## #############
## Custom argument types for conversion of skeleton profile names and
## joint names to the ids used by OpenNI.

critcl::argtype KJointProfile {
    if (Tcl_GetIndexFromObj (interp, @@, @stem@_skeleton_profile,
			     "profile", 0, &@A) != TCL_OK) {
	return TCL_ERROR;
    }
    @A ++; /* Convert from Tcl's 0-indexed value to OpenNI's 1-indexing. */
} int int

critcl::argtype KJoint {
    if (Tcl_GetIndexFromObj (interp, @@, @stem@_skeleton_joint,
			     "joint", 0, &@A) != TCL_OK) {
	return TCL_ERROR;
    }
    @A ++; /* Convert from Tcl's 0-indexed value to OpenNI's 1-indexing. */
} int int

# # ## ### ##### ######## #############

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

    method is-profile-available proc {KJointProfile profile} bool {
	return xnIsProfileAvailable (instance->handle, profile);
    }

    method available-profiles proc {} Tcl_Obj* {
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

	return Tcl_NewListObj (pc, pv);
    }

    method all-profiles proc {} Tcl_Obj* {
	int available, profile, pc;
	Tcl_Obj* pv [5];

	for (profile = XN_SKEL_PROFILE_NONE, pc = 0;
	     profile <= XN_SKEL_PROFILE_HEAD_HANDS;
	     profile++) {
	    pv [pc] = Tcl_NewStringObj (@stem@_skeleton_profile [profile-1],-1);
	    pc ++;
	}

	return Tcl_NewListObj (pc, pv);
    }

    method set-profile proc {KJointProfile profile} XnStatus {
	return xnSetSkeletonProfile (instance->handle, profile);
    }

    method set-smoothing proc {double factor} XnStatus {
	return xnSetSkeletonSmoothing (instance->handle, factor);
    }

    method start-tracking proc {int id} XnStatus {
	return xnStartSkeletonTracking (instance->handle, id);
    }

    method stop-tracking proc {int id} XnStatus {
	return xnStopSkeletonTracking (instance->handle, id);
    }

    method reset-tracking proc {int id} XnStatus {
	return xnResetSkeleton (instance->handle, id);
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

    method request-calibration proc {int id bool force} XnStatus {
	return xnRequestSkeletonCalibration (instance->handle, id, force);
    }

    method abort-calibration proc {int id} XnStatus {
	return xnAbortSkeletonCalibration (instance->handle, id);
    }

    # XXX The higher level wrapper handles vfs, by routing through a
    # XXX temp file when needed.

    method save-calibration-file proc {int id char* path} XnStatus {
	return xnSaveSkeletonCalibrationDataToFile (instance->handle, id, path);
    }

    method load-calibration-file proc {int id char* path} XnStatus {
	return xnLoadSkeletonCalibrationDataFromFile (instance->handle, id, path);
    }

    method save-calibration-slot proc {int id int slot} XnStatus {
	return xnSaveSkeletonCalibrationData (instance->handle, id, slot);
    }

    method load-calibration-slot proc {int id int slot} XnStatus {
	return xnLoadSkeletonCalibrationData (instance->handle, id, slot);
    }

    method clear-calibration-slot proc {int slot} XnStatus {
	return xnClearSkeletonCalibrationData (instance->handle, slot);
    }

    method is-calibration-slot proc {int slot} bool {
	return xnClearSkeletonCalibrationData (instance->handle, slot);
    }

    method is-joint-available proc {KJoint joint} bool {
	return xnIsJointAvailable (instance->handle, joint);
    }

    method is-joint-active proc {KJoint joint} bool {
	return xnIsJointActive (instance->handle, joint);
    }

    method set-joint-active proc {KJoint joint bool active} XnStatus {
	return xnSetJointActive (instance->handle, joint, active);
    }

    method active-joints proc {} ok {
	XnStatus s;
	XnUInt16 n;
	XnSkeletonJoint j [XN_SKEL_RIGHT_FOOT+1];
	Tcl_Obj*       jn [XN_SKEL_RIGHT_FOOT+1];
	int k;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	n = XN_SKEL_RIGHT_FOOT+1;
	s = xnEnumerateActiveJoints (instance->handle, j, &n);
	CHECK_STATUS_RETURN;

	for (k=0; k < n; k++) {
            jn [k] = Tcl_NewStringObj (@stem@_skeleton_joint [j[k]-1],-1);
	}

	Tcl_SetObjResult (interp, Tcl_NewListObj (n, jn));
	return TCL_OK;
    }

    method get-joint proc {int user KJoint joint} Tcl_Obj* {
	return @stem@_get_joint (interp, instance, user, joint);
    }

    method get-skeleton proc {int user} Tcl_Obj* {
	return @stem@_get_skeleton (interp, instance, user);
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
