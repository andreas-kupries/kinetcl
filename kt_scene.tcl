
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

    method map proc {} Tcl_Obj* {
	crimp_image* image;
	XnSceneMetaData* meta;

	meta = xnAllocateSceneMetaData ();
	xnGetSceneMetaData (instance->handle, meta);

	/* Allocate and fill a CRIMP grey16 image with the
	 * scene segmentation.
	 *
	 * NOTE: We should assert bytes-pixel == 2
	 */

	image = crimp_new_grey16 (meta->pMap->Res.X, meta->pMap->Res.Y);

	/* Assert size equivalence */
	if ((SZ (image)*crimp_image_area(image)) != meta->pMap->pOutput->nDataSize) {
	    Tcl_Panic ("raw pixel size mismatch");
	}

	memcpy (image->pixel, meta->pData,
		meta->pMap->pOutput->nDataSize);

	xnFreeSceneMetaData (meta);

	return crimp_new_image_obj (image);
    }

    method meta proc {} ok {
	XnSceneMetaData* meta;

	meta = xnAllocateSceneMetaData ();

	xnGetSceneMetaData (instance->handle, meta);
	Tcl_SetObjResult (interp, kinetcl_convert_scene_metadata (meta));

	xnFreeSceneMetaData (meta);
	return TCL_OK;
    }

    method floor proc {} ok {
	XnPlane3D floor;
	XnStatus s;
	Tcl_Obj* res;

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
