# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapUserSkeleton {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    mdef need-pose { /* Syntax: <instance> need-pose */
	int need;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	need = xnNeedPoseForSkeletonCalibration (instance->handle);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (need));
	return TCL_OK;
    }

    # XXX Bogosity
    # XXX    XnStatus xnGetSkeletonCalibrationPose (XnNodeHandle HI, XnChar *strPose)
    # _get_ the pose, but 'strPose' is marked as input parameter, and
    # we do not know the length we would have pre-allocate either,
    # should the library try to fill the string.

    mdef is-profile-available { /* Syntax: <instance> is-profile-available <profile> */
	int available, profile;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "profile");
	    return TCL_ERROR;
	}

	if (Tcl_GetIndexFromObj (interp, objv[2], 
				 @stem@_skeleton_profile,
				 "profile", 0, &profile) != TCL_OK) {
	    return TCL_ERROR;
	}

	available = xnIsProfileAvailable (instance->handle, profile);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (available));
	return TCL_OK;
    }

    mdef set-profile { /* Syntax: <instance> set-profile <profile> */
	int available, profile;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "profile");
	    return TCL_ERROR;
	}

	if (Tcl_GetIndexFromObj (interp, objv[2], 
				 @stem@_skeleton_profile,
				 "profile", 0, &profile) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetSkeletonProfile (instance->handle, profile);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef set-smoothing { /* Syntax: <instance> set-smoothing <factor> */
	double factor;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "factor");
	    return TCL_ERROR;
	}

	if (Tcl_GetDoubleFromObj (interp, objv[2], &factor) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetSkeletonSmoothing (instance->handle, factor);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef start-tracking { /* Syntax: <instance> start-tracking <id> */
	int id;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnStartSkeletonTracking (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef stop-tracking { /* Syntax: <instance> stop-tracking <id> */
	int id;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnStopSkeletonTracking (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef reset-tracking { /* Syntax: <instance> reset-tracking <id> */
	int id;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnResetSkeleton (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef is-tracking { /* Syntax: <instance> is-tracking <id> */
	int id;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnIsSkeletonTracking (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef is-calibrated { /* Syntax: <instance> is-calibrated <id> */
	int id;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnIsSkeletonCalibrated (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef is-calibrating { /* Syntax: <instance> is-calibrating <id> */
	int id;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[1], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnIsSkeletonCalibrating (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef request-calibration { /* Syntax: <instance> request-calibration <id> <force> */
	int id, force;
	XnStatus s;

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id force");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[1], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	if (Tcl_GetBooleanFromObj (interp, objv[1], &force) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnRequestSkeletonCalibration (instance->handle, id, force);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef abort-calibration { /* Syntax: <instance> abort-calibration <id> */
	int id;
	XnStatus s;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[1], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnAbortSkeletonCalibration (instance->handle, id);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    # XXX The higher level wrapper handles vfs, by routing through a
    # XXX temp file when needed.

    mdef save-calibration-file { /* Syntax: <instance> save-calibration-file <id> <path> */
	int id;
	XnStatus s;

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id path");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSaveSkeletonCalibrationDataToFile (instance->handle, id, 
						 Tcl_GetString (objv [3]));
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef load-calibration-file { /* Syntax: <instance> load-calibration-file <id> <path> */
	int id;
	XnStatus s;

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id path");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnLoadSkeletonCalibrationDataFromFile (instance->handle, id, 
						   Tcl_GetString (objv [3]));
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef save-calibration-slot { /* Syntax: <instance> save-calibration <id> <slot> */
	int id, slot;
	XnStatus s;

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id slot");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[3], &slot) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSaveSkeletonCalibrationData (instance->handle, id, slot);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef load-calibration-slot { /* Syntax: <instance> load-calibration-slot <id> <slot> */
	int id, slot;
	XnStatus s;

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "id slot");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[3], &slot) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnLoadSkeletonCalibrationData (instance->handle, id, slot);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef clear-calibration-slot { /* Syntax: <instance> clear-calibration-slot <slot> */
	int slot;
	XnStatus s;

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "slot");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &slot) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnClearSkeletonCalibrationData (instance->handle, slot);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    mdef is-calibration-slot { /* Syntax: <instance> is-calibration-slot <slot> */
	int slot, used;

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "slot");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &slot) != TCL_OK) {
	    return TCL_ERROR;
	}

	used = xnClearSkeletonCalibrationData (instance->handle, slot);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (used));
	return TCL_OK;
    }

    mdef is-joint-available { /* Syntax: <instance> is-joint-available <joint> */
	int available, joint;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "joint");
	    return TCL_ERROR;
	}

	if (Tcl_GetIndexFromObj (interp, objv[2], 
				 @stem@_skeleton_joint,
				 "joint", 0, &joint) != TCL_OK) {
	    return TCL_ERROR;
	}

	available = xnIsJointAvailable (instance->handle, joint);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (available));
	return TCL_OK;
    }

    mdef is-joint-active { /* Syntax: <instance> is-joint-active <joint> */
	int active, joint;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "joint");
	    return TCL_ERROR;
	}

	if (Tcl_GetIndexFromObj (interp, objv[2], 
				 @stem@_skeleton_joint,
				 "joint", 0, &joint) != TCL_OK) {
	    return TCL_ERROR;
	}

	active = xnIsJointActive (instance->handle, joint);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (active));
	return TCL_OK;
    }

    mdef set-joint-active { /* Syntax: <instance> set-joint-active <joint> <active> */
	int active, joint;
	XnStatus s;

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "joint active");
	    return TCL_ERROR;
	}

	if (Tcl_GetIndexFromObj (interp, objv[2], 
				 @stem@_skeleton_joint,
				 "joint", 0, &joint) != TCL_OK) {
	    return TCL_ERROR;
	}

	if (Tcl_GetBooleanFromObj (interp, objv[3], &active) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetJointActive (instance->handle, joint, active);
	CHECK_STATUS_RETURN;

	Tcl_SetObjResult (interp, Tcl_NewIntObj (active));
	return TCL_OK;
    }

    mdef active-joints { /* Syntax: <instance> active-joints */
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
            jn [k] = Tcl_NewStringObj (@stem@_skeleton_joint [j[k]],-1);
	}

	Tcl_SetObjResult (interp, Tcl_NewListObj (n, jn));
	return TCL_OK;
    }

    mdef get-joint { /* Syntax: <instance> get-joint <user> <joint> */
	int active, joint, id, k;
	XnStatus s;
	XnSkeletonJointTransformation t;
	Tcl_Obj* coord  [3];
	Tcl_Obj* matrix [9];
	Tcl_Obj* pos [2];
	Tcl_Obj* ori [2];
	Tcl_Obj* result [2];

	if (objc != 4) {
	    Tcl_WrongNumArgs (interp, 2, objv, "joint");
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[2], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	if (Tcl_GetIndexFromObj (interp, objv[3], 
				 @stem@_skeleton_joint,
				 "joint", 0, &joint) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnGetSkeletonJoint (instance->handle, id, joint, &t);
	CHECK_STATUS_RETURN;

	/* t.position.position.X         */
	/* t.position.position.Y         */
	/* t.position.position.Z         */
	/* t.position.fConfidence        */
	/* t.orientation.orientation [9] */
	/* t.orientation.fConfidence     */

	coord [0] = Tcl_NewDoubleObj (t.position.position.X);
	coord [1] = Tcl_NewDoubleObj (t.position.position.Y);
	coord [2] = Tcl_NewDoubleObj (t.position.position.Z);

	pos [0] = Tcl_NewDoubleObj (t.position.fConfidence);
	pos [1] = Tcl_NewListObj (3, coord);

	for (k = 0; k < 9; k++) {
	    matrix [k] = Tcl_NewDoubleObj (t.orientation.orientation.elements [k]);
        }

	ori [0] = Tcl_NewDoubleObj (t.orientation.fConfidence);
	ori [1] = Tcl_NewListObj (9, matrix);

	result [0] = Tcl_NewListObj (2, pos);
	result [1] = Tcl_NewListObj (2, ori);

	Tcl_SetObjResult (interp, Tcl_NewListObj (2, result));
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
    }

    # # ## ### ##### ######## #############
    ## Callbacks, joint configuration changes, calibration process events

    ::kt_callback jointConfigChange \
	xnRegisterToJointConfigurationChange \
	xnUnregisterFromJointConfigurationChange \
	{} {}

    ::kt_callback calibrationStart \
	xnRegisterToCalibrationStart \
	xnUnregisterFromCalibrationStart \
	{{XnUserID user}} {
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewIntObj (user));
	}

    ::kt_callback calibrationComplete \
	xnRegisterToCalibrationComplete \
	xnUnregisterFromCalibrationComplete \
	{
	    {XnUserID            user}
	    {XnCalibrationStatus cStatus}
	} {
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewIntObj (user));
	    Tcl_ListObjAppendElement (interp, cmd,
				      Tcl_NewStringObj (@stem@_skeleton_calibration [cStatus],-1));
	}

    ::kt_callback calibrationProgress \
	xnRegisterToCalibrationInProgress \
	xnUnregisterFromCalibrationInProgress \
	{
	    {XnUserID            user}
	    {XnCalibrationStatus cStatus}
	} {
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewIntObj (user));
	    Tcl_ListObjAppendElement (interp, cmd,
				      Tcl_NewStringObj (@stem@_skeleton_calibration [cStatus],-1));
	}

    # NOTE
    # xnRegisterCalibrationCallbacks   | Deprecated in favor of the above calibration
    # xnUnregisterCalibrationCallbacks | start, progress, and complete callbacks.

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
