# # ## ### ##### ######## #############
## Base Class

critcl::class def ::kinetcl::Base {
    # # ## ### ##### ######## #############
    ::kt_abstract_class {
	instance->capnames = ComputeMethodList (@stem@_tcl_capability_names);
	Tcl_IncrRefCount (instance->capnames);
    } {
	Tcl_DecrRefCount (instance->capnames);
    }

    field Tcl_Obj* capnames {Fixed list of possible capabilities}

    # # ## ### ##### ######## #############
    ## Methods managing the OpenNI handle from the Tcl level, and
    ## other specialities.

    mdef @mark { /* Internal method, no argument checking. */
	/* Save the OpenNI handle in the shared kinetcl context.
	 * -- This is done (implicitly) during construction, so that the C-level
	 *    base classes can find the handle/node they are to use.
	 * -- This is also done (explicitly through here) by 'Valid',
	 *    for methods which take another node as argument.
	 */
	instance->context->mark = instance->handle;
	return TCL_OK;
    }

    mdef @unmark { /* Internal method, no argument checking. */
	/* Remove the OpenNI handle from the shared stash.
	 * IOW clean the state up.
	 */
	instance->context->mark = NULL;
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    mdef is-capable-of { /* Syntax: <instance> is-capable-of capName */
	/* List of cap names - XnTypes.h, as defines XN_CAPABILITY_xxx */

	XnBool supported;
	const char* capName;
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

    mdef node-name { /* Syntax: <instance> ni-name */
	Tcl_SetObjResult (interp, Tcl_NewStringObj (xnGetNodeName (instance->handle),-1));
	return TCL_OK;
    }

    mdef node-info { /* Syntax: <instance> node-info */
	XnNodeInfo*                        ni = xnGetNodeInfo (instance->handle);
	const XnProductionNodeDescription* d  = xnNodeInfoGetDescription (ni);
	Tcl_Obj* vv [4];
	Tcl_Obj* res = Tcl_NewDictObj ();

	vv [0] = Tcl_NewIntObj (d->Version.nMajor);
	vv [1] = Tcl_NewIntObj (d->Version.nMinor);
	vv [2] = Tcl_NewIntObj (d->Version.nMaintenance);
	vv [3] = Tcl_NewIntObj (d->Version.nBuild);

	Tcl_DictObjPut (interp, res, Tcl_NewStringObj ("type",-1),
			d->Type >= XN_NODE_TYPE_FIRST_EXTENSION
			? Tcl_NewIntObj (d->Type)
			: Tcl_NewStringObj (kinetcl_ptype [d->Type+1], -1));
	Tcl_DictObjPut (interp, res, Tcl_NewStringObj ("vendor",-1),
			Tcl_NewStringObj (d->strVendor, -1));
	Tcl_DictObjPut (interp, res, Tcl_NewStringObj ("name",-1),
			Tcl_NewStringObj (d->strName, -1));
	Tcl_DictObjPut (interp, res, Tcl_NewStringObj ("version",-1),
			Tcl_NewListObj (4, vv));
	Tcl_DictObjPut (interp, res, Tcl_NewStringObj ("create",-1),
			Tcl_NewStringObj (xnNodeInfoGetCreationInfo (ni), -1));

	/* ni is owned by the system, do not release - xnNodeInfoFree (ni);
	 */
	Tcl_SetObjResult (interp, res);
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
	    "hand-touching-fov-edge",
	    "hue",
	    "iris",
	    "lock-aware",
	    "lowlight-compensation",
	    "mirror",
	    "pan",
	    "user-pose-detection",
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

        static const char* kinetcl_ptype [] = {
	    "invalid",	  /* XN_NODE_TYPE_INVALID  = -1	*/
	    "",		  /* -- undefined -- gap -- */
	    "device",	  /* XN_NODE_TYPE_DEVICE   = 1	*/
	    "depth",	  /* XN_NODE_TYPE_DEPTH    = 2	*/
	    "image",	  /* XN_NODE_TYPE_IMAGE    = 3	*/
	    "audio",	  /* XN_NODE_TYPE_AUDIO    = 4	*/
	    "ir",	  /* XN_NODE_TYPE_IR       = 5	*/
	    "user",	  /* XN_NODE_TYPE_USER     = 6	*/
	    "recorder",	  /* XN_NODE_TYPE_RECORDER = 7	*/
	    "player",	  /* XN_NODE_TYPE_PLAYER   = 8	*/
	    "gesture",	  /* XN_NODE_TYPE_GESTURE  = 9	*/
	    "scene",	  /* XN_NODE_TYPE_SCENE           = 10	*/
	    "hands",	  /* XN_NODE_TYPE_HANDS           = 11	*/
	    "codec",	  /* XN_NODE_TYPE_CODEC           = 12	*/
	    "production", /* XN_NODE_TYPE_PRODUCTION_NODE = 13	*/
	    "generator",  /* XN_NODE_TYPE_GENERATOR       = 14	*/
	    "map",	  /* XN_NODE_TYPE_MAP_GENERATOR   = 15	*/
	    "script",	  /* XN_NODE_TYPE_SCRIPT          = 16	*/
	    NULL
	};

	static Tcl_Obj*
	kinetcl_convert_3d (const XnVector3D* vec)
	{
	    Tcl_Obj* coords [3];

	    coords [0] = Tcl_NewDoubleObj (vec->X);
	    coords [1] = Tcl_NewDoubleObj (vec->Y);
	    coords [2] = Tcl_NewDoubleObj (vec->Z);

	    return Tcl_NewListObj (3, coords);
	}

	static int
	kinetcl_convert_to3d (Tcl_Interp* interp, Tcl_Obj* ivec, XnVector3D* vec)
	{
	    Tcl_Obj** v;
	    int n;
	    double x, y, z;

	    if (Tcl_ListObjGetElements (interp, ivec, &n, &v) != TCL_OK) {
		Tcl_AppendResult (interp, "Expected coordinate list", NULL);
		return TCL_ERROR;
	    }
	    if (n != 3) {
		Tcl_AppendResult (interp, "Expected 3 coordinates", NULL);
		return TCL_ERROR;
	    }

	    if (Tcl_GetDoubleFromObj (interp, v [0], &x) != TCL_OK) { return TCL_ERROR; }
	    if (Tcl_GetDoubleFromObj (interp, v [1], &y) != TCL_OK) { return TCL_ERROR; }
	    if (Tcl_GetDoubleFromObj (interp, v [2], &z) != TCL_OK) { return TCL_ERROR; }

	    if (vec) {
		vec->X = x;
		vec->Y = y;
		vec->Z = z;
	    }

	    return TCL_OK;
	}
    }

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
