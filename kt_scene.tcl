
# # ## ### ##### ######## #############
## Scene Analyzer

critcl::class def ::kinetcl::Scene {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain scene analyzer object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateSceneAnalyzer (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############

    mdef map { /* Syntax: <instance> map */
	crimp_image* image;
	XnSceneMetaData* meta;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	meta = xnAllocateSceneMetaData ();
	xnGetSceneMetaData (instance->handle, meta);

	/* Allocate and fill a CRIMP grey16 image with the
	 * scene segmentation.
	 *
	 * NOTE: We should assert bytes-pixel == 2
	 */

	image = crimp_new_grey16 (meta->pMap->Res.X, meta->pMap->Res.Y);

	kinetcl_fill_image (image, meta->pData, meta->pMap->pOutput->nDataSize);

	xnFreeSceneMetaData (meta);

	Tcl_SetObjResult (interp, crimp_new_image_obj (image));
	return TCL_OK;
    }

    mdef meta { /* Syntax: <instance> meta */
	XnSceneMetaData* meta;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	meta = xnAllocateSceneMetaData ();

	xnGetSceneMetaData (instance->handle, meta);
	Tcl_SetObjResult (interp, kinetcl_convert_scene_metadata (meta));

	xnFreeSceneMetaData (meta);
	return TCL_OK;
    }

    mdef floor { /* Syntax: <instance> floor */
	XnPlane3D floor;
	XnStatus s;
	Tcl_Obj* res;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnGetFloor (instance->handle, &floor);
	CHECK_STATUS_RETURN;

	res = Tcl_NewDictObj ();
	Tcl_DictObjPut (interp, res, Tcl_NewStringObj ("point",-1),
			kinetcl_convert_3d (&floor.ptPoint));
	Tcl_DictObjPut (interp, res, Tcl_NewStringObj ("normal",-1),
			kinetcl_convert_3d (&floor.vNormal));

	Tcl_SetObjResult (interp, res);
	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    support {
	static Tcl_Obj*
	kinetcl_convert_scene_metadata (XnSceneMetaData* meta)
	{
	    Tcl_Obj* res = Tcl_NewDictObj ();

	    /* Only image specific information is pData, the raw bytes */
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("map",-1),
			    kinetcl_convert_map_metadata (meta->pMap));
	    return res;
	}
    }

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
