# # ## ### ##### ######## #############
## Base Class

critcl::class def kinetcl::Base {
    # # ## ### ##### ######## #############
    ::kt_abstract_class {
	instance->capnames = ComputeMethodList (@stem@_tcl_capability_names);
	Tcl_IncrRefCount (instance->capnames);
    } {
	Tcl_DecrRefCount (instance->capnames);
    }

    field Tcl_Obj* capnames {Fixed list of possible capabilities}

    # # ## ### ##### ######## #############
    mdef isCapableOf { /* Syntax: <instance> isCapableOf capName */
	/* List of cap names - XnTypes.h, as defines XN_CAPABILITY_xxx */

	XnBool supported;
	char* capName;
	int cap;

	if (objc != 3) {
	    Tcl_WrongNumArgs (interp, 2, objv, "capName");
	    return TCL_ERROR;
	}

	if (Tcl_GetIndexFromObj (interp, objv[2], 
				 @stem@_tcl_capability_names,
				 "capability", 0, &cap) != TCL_OK) {
	    return TCL_ERROR;
	}

	/* Translate Tcl to C/OpenNI */
	capName = @stem@_oni_capability_names [cap];

	supported = xnIsCapabilitySupported (instance->handle, capName);
	Tcl_SetObjResult (interp, Tcl_NewIntObj (supported));
	return TCL_OK;
    }

    mdef capabilities { /* Syntax: <instance> capabilities */
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, instance->capnames);
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    # set int, real, string, general properties - by name - XnPropNames.h?
    # get int, real, string, general properties - by name
    # locking, transactional changes
    # add/remove needed nodes (dependencies)


    # # ## ### ##### ######## #############

    support {
	/* Replication of the capability defines as a Tcl enumeration,
	 * for nicer names and introspection.
	 */

	static const char* @stem@_tcl_capability_names [] = {
	    "alternative-viewpoint",		/* XXX TODO map to classes which may support it */
	    "antiflicker",
	    "backlight-compensation",
	    "brightness",
	    "color-temperature",
	    "contrast",
	    "cropping",
	    "device-identification",
	    "error-state",
	    "exposure",
	    "extended-serialization",
	    "focus",
	    "framesync",
	    "gain",
	    "gamma",
	    "hands-hand-touching-fov-edge",
	    "hue",
	    "iris",
	    "lock-aware",
	    "lowlight-compensation",
	    "mirror",
	    "pan",
	    "user-poseDetection",
	    "roll",
	    "saturation",
	    "sharpness",
	    "user-skeleton",
	    "tilt",
	    "user-position",
	    "zoom",
	    NULL
	};

	static const char* @stem@_oni_capability_names [] = {
	    XN_CAPABILITY_ALTERNATIVE_VIEW_POINT,
	    XN_CAPABILITY_ANTI_FLICKER,
	    XN_CAPABILITY_BACKLIGHT_COMPENSATION,
	    XN_CAPABILITY_BRIGHTNESS,
	    XN_CAPABILITY_COLOR_TEMPERATURE,
	    XN_CAPABILITY_CONTRAST,
	    XN_CAPABILITY_CROPPING,
	    XN_CAPABILITY_DEVICE_IDENTIFICATION,
	    XN_CAPABILITY_ERROR_STATE,
	    XN_CAPABILITY_EXPOSURE,
	    XN_CAPABILITY_EXTENDED_SERIALIZATION,
	    XN_CAPABILITY_FOCUS,
	    XN_CAPABILITY_FRAME_SYNC,
	    XN_CAPABILITY_GAIN,
	    XN_CAPABILITY_GAMMA,
	    XN_CAPABILITY_HAND_TOUCHING_FOV_EDGE,
	    XN_CAPABILITY_HUE,
	    XN_CAPABILITY_IRIS,
	    XN_CAPABILITY_LOCK_AWARE,
	    XN_CAPABILITY_LOW_LIGHT_COMPENSATION,
	    XN_CAPABILITY_MIRROR,
	    XN_CAPABILITY_PAN,
	    XN_CAPABILITY_POSE_DETECTION,
	    XN_CAPABILITY_ROLL,
	    XN_CAPABILITY_SATURATION,
	    XN_CAPABILITY_SHARPNESS,
	    XN_CAPABILITY_SKELETON,
	    XN_CAPABILITY_TILT,
	    XN_CAPABILITY_USER_POSITION,
	    XN_CAPABILITY_ZOOM,
	    NULL
	};
    }

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
