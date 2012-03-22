
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
	XnDepthMetaData* meta;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	meta = xnAllocateDepthMetaData ();

	xnGetDepthMetaData (instance->handle, meta);
	Tcl_SetObjResult (interp, kinetcl_convert_depth_metadata (meta));

	xnFreeDepthMetaData (meta);
	return TCL_OK;
    }

    mdef map { /* Syntax: <instance> map */
	crimp_image* image;
	XnDepthMetaData* meta;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

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

    mdef projective2world { /* Syntax: <instance> 2world point... */
	XnStatus s;
	int i, lc, pc, res = TCL_ERROR;
	double v;
	Tcl_Obj** lv;
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

	for (i = 0; i < lc; i++) {
	    if ((Tcl_ListObjGetElements (interp, lv[i], &pc, &pv) != TCL_OK) || (pc != 3)) {
		return TCL_ERROR;
	    }
	    if (Tcl_GetDoubleFromObj (interp, pv [0], &v) != TCL_OK) { return TCL_ERROR; }
	    if (Tcl_GetDoubleFromObj (interp, pv [1], &v) != TCL_OK) { return TCL_ERROR; }
	    if (Tcl_GetDoubleFromObj (interp, pv [2], &v) != TCL_OK) { return TCL_ERROR; }
	}

	aprojective = (XnPoint3D*) ckalloc (lc * sizeof (XnPoint3D));
	aworld      = (XnPoint3D*) ckalloc (lc * sizeof (XnPoint3D));

	for (i = 0; i < lc; i++) {
	    Tcl_ListObjGetElements (interp, lv[i], &pc, &pv);
	    Tcl_GetDoubleFromObj (interp, pv [0], &v); aprojective [i].X = v;
	    Tcl_GetDoubleFromObj (interp, pv [1], &v); aprojective [i].Y = v;
	    Tcl_GetDoubleFromObj (interp, pv [2], &v); aprojective [i].Z = v;
	}

	s = xnConvertProjectiveToRealWorld (instance->handle, lc, aprojective, aworld);
	CHECK_STATUS_GOTO;

	rv = Tcl_NewListObj (0, NULL);
	for (i = 0; i < lc; i++) {
	    Tcl_ListObjAppendElement (interp, rv, kinetcl_convert_3d (&aworld [i]));
	}

	Tcl_SetObjResult (interp, rv);
	res = TCL_OK;
    error:
	ckfree ((char*) aprojective);
	ckfree ((char*) aworld);
	return res;
    }

    mdef world2projective { /* Syntax: <instance> 2projective point... */
	XnStatus s;
	int i, lc, pc, res = TCL_ERROR;
	double v;
	Tcl_Obj** lv;
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

	for (i = 0; i < lc; i++) {
	    if ((Tcl_ListObjGetElements (interp, lv[i], &pc, &pv) != TCL_OK) || (pc != 3)) {
		return TCL_ERROR;
	    }
	    if (Tcl_GetDoubleFromObj (interp, pv [0], &v) != TCL_OK) { return TCL_ERROR; }
	    if (Tcl_GetDoubleFromObj (interp, pv [1], &v) != TCL_OK) { return TCL_ERROR; }
	    if (Tcl_GetDoubleFromObj (interp, pv [2], &v) != TCL_OK) { return TCL_ERROR; }
	}

	aworld = (XnPoint3D*) ckalloc (lc * sizeof (XnPoint3D));
	aprojective      = (XnPoint3D*) ckalloc (lc * sizeof (XnPoint3D));

	for (i = 0; i < lc; i++) {
	    Tcl_ListObjGetElements (interp, lv[i], &pc, &pv);
	    Tcl_GetDoubleFromObj (interp, pv [0], &v); aworld [i].X = v;
	    Tcl_GetDoubleFromObj (interp, pv [1], &v); aworld [i].Y = v;
	    Tcl_GetDoubleFromObj (interp, pv [2], &v); aworld [i].Z = v;
	}

	s = xnConvertRealWorldToProjective (instance->handle, lc, aworld, aprojective);
	CHECK_STATUS_GOTO;

	rv = Tcl_NewListObj (0, NULL);
	for (i = 0; i < lc; i++) {
	    Tcl_ListObjAppendElement (interp, rv, kinetcl_convert_3d (&aprojective [i]));
	}

	Tcl_SetObjResult (interp, rv);
	res = TCL_OK;
    error:
	ckfree ((char*) aworld);
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
