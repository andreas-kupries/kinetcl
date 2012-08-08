
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

    method max-depth proc {} ok {
	XnDepthPixel depth;

	depth = xnGetDeviceMaxDepth (instance->handle);
	if (depth == ((XnDepthPixel) -1)) {
	    Tcl_AppendResult (interp, "Inheritance error: Not a generator", NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewIntObj (depth));
	return TCL_OK;
    }

    method fov proc {} ok {
	Tcl_Obj* rfov [2];
	XnFieldOfView fov;
	XnStatus s;

	s = xnGetDepthFieldOfView (instance->handle, &fov);
	CHECK_STATUS_RETURN;

	rfov [0] = Tcl_NewDoubleObj (fov.fHFOV);
	rfov [1] = Tcl_NewDoubleObj (fov.fVFOV);

	Tcl_SetObjResult (interp, Tcl_NewListObj (2, rfov));
	return TCL_OK;
    }

    method meta proc {} ok {
	XnDepthMetaData* meta;

	meta = xnAllocateDepthMetaData ();

	xnGetDepthMetaData (instance->handle, meta);
	Tcl_SetObjResult (interp, kinetcl_convert_depth_metadata (meta));

	xnFreeDepthMetaData (meta);
	return TCL_OK;
    }

    method map proc {} ok {
	crimp_image* image;
	XnDepthMetaData* meta;

	meta = xnAllocateDepthMetaData ();
	xnGetDepthMetaData (instance->handle, meta);

	/* Allocate and fill a CRIMP grey16 image with the
	 * depth map.
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

	xnFreeDepthMetaData (meta);

	Tcl_SetObjResult (interp, crimp_new_image_obj (image));
	return TCL_OK;
    }

    # TODO this and next, as command...
    method projective2world command {point...} {
	XnStatus s;
	int i, lc, pc, res = TCL_ERROR;
	double v;
	Tcl_Obj* const* lv;
	Tcl_Obj *p, *rv;
	Tcl_Obj** pv;
	XnPoint3D* aprojective;
	XnPoint3D* aworld;

	if (objc == 2) {
	    return TCL_OK;
	}

	lc = objc - 2;
	lv = objv + 2;

	/* Check input for proper format */
	aprojective = (XnPoint3D*) ckalloc (lc * sizeof (XnPoint3D));

	for (i = 0; i < lc; i++) {
	    if (kinetcl_convert_to3d (interp, lv [i], &aprojective [i]) != TCL_OK) {
		ckfree ((char*) aprojective);
		return TCL_ERROR;
	    }
	}

	aworld = (XnPoint3D*) ckalloc (lc * sizeof (XnPoint3D));
	s = xnConvertProjectiveToRealWorld (instance->handle, lc, aprojective, aworld);
	ckfree ((char*) aprojective);

	CHECK_STATUS_GOTO;

	rv = Tcl_NewListObj (0, NULL);
	for (i = 0; i < lc; i++) {
	    Tcl_ListObjAppendElement (interp, rv, kinetcl_convert_3d (&aworld [i]));
	}

	Tcl_SetObjResult (interp, rv);
	res = TCL_OK;
    error:
	ckfree ((char*) aworld);
	return res;
    }

    method world2projective command {point...} {
	XnStatus s;
	int i, lc, pc, res = TCL_ERROR;
	double v;
	Tcl_Obj* const* lv;
	Tcl_Obj *p, *rv;
	Tcl_Obj** pv;
	XnPoint3D* aworld;
	XnPoint3D* aprojective;

	if (objc == 2) {
	    return TCL_OK;
	}

	lc = objc - 2;
	lv = objv + 2;

	/* Check input for proper format */
	aworld = (XnPoint3D*) ckalloc (lc * sizeof (XnPoint3D));

	for (i = 0; i < lc; i++) {
	    if (kinetcl_convert_to3d (interp, lv [i], &aworld [i]) != TCL_OK) {
		ckfree ((char*) aprojective);
		return TCL_ERROR;
	    }
	}

	aprojective = (XnPoint3D*) ckalloc (lc * sizeof (XnPoint3D));

	s = xnConvertRealWorldToProjective (instance->handle, lc, aworld, aprojective);
	ckfree ((char*) aworld);

	CHECK_STATUS_GOTO;

	rv = Tcl_NewListObj (0, NULL);
	for (i = 0; i < lc; i++) {
	    Tcl_ListObjAppendElement (interp, rv, kinetcl_convert_3d (&aprojective [i]));
	}

	Tcl_SetObjResult (interp, rv);
	res = TCL_OK;
    error:
	ckfree ((char*) aprojective);
	return res;
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
