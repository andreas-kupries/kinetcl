
# # ## ### ##### ######## #############
## Depth Generator

critcl::class def ::kinetcl::Depth {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain depth generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateDepthGenerator (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############

    mdef max-depth { /* Syntax: <instance> max-depth */
	XnDepthPixel depth;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	depth = xnGetDeviceMaxDepth (instance->handle);
	if (depth == ((XnDepthPixel) -1)) {
	    Tcl_AppendResult (interp, "Inheritance error: Not a generator", NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewIntObj (depth));
	return TCL_OK;
    }

    mdef fov { /* Syntax: <instance> fov */
	Tcl_Obj* rfov [2];
	XnFieldOfView fov;
	XnStatus s;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnGetDepthFieldOfView (instance->handle, &fov);
	CHECK_STATUS_RETURN;

	rfov [0] = Tcl_NewDoubleObj (fov.fHFOV);
	rfov [1] = Tcl_NewDoubleObj (fov.fVFOV);

	Tcl_SetObjResult (interp, Tcl_NewListObj (2, rfov));
	return TCL_OK;
    }

    mdef meta { /* Syntax: <instance> meta */
	XnDepthMetaData* meta = xnAllocateDepthMetaData ();

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	xnGetDepthMetaData (instance->handle, meta);
	Tcl_SetObjResult (interp, kinetcl_convert_depth_metadata (meta));

	xnFreeDepthMetaData (meta);
	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    ::kt_callback depthfov \
	xnRegisterToDepthFieldOfViewChange \
	xnUnregisterFromDepthFieldOfViewChange \
	{} {}

    # # ## ### ##### ######## #############

    support {
	static Tcl_Obj*
	kinetcl_convert_depth_metadata (XnDepthMetaData* meta)
	{
	    Tcl_Obj* res = Tcl_NewDictObj ();
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("max-depth",-1),
			    Tcl_NewIntObj (meta->nZRes));
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("map",-1),
			    kinetcl_convert_map_metadata (meta->pMap));
	    return res;
	}
    }

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
if 0 {

XnStatus
xnConvertProjectiveToRealWorld
 (XnNodeHandle hInstance,
 XnUInt32 nCount,
 const XnPoint3D *aProjective, XnPoint3D *aRealWorld)

XnStatus
xnConvertRealWorldToProjective
 (XnNodeHandle hInstance,
 XnUInt32 nCount,
 const XnPoint3D *aRealWorld, XnPoint3D *aProjective)

}
