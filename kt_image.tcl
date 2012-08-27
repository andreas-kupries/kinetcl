
# # ## ### ##### ######## #############
## Image Generator

critcl::class def ::kinetcl::Image {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain image generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateImageGenerator (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############

    mdef formats { /* Syntax: <instance> formats */
	int i, lc;
	Tcl_Obj* lv [kinetcl_NUM_PIXELFORMATS];

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	for (lc = 0, i = 0;
	     i < kinetcl_NUM_PIXELFORMATS;
	     i++) {
	   /* i, array are 0-indexed, pixelformats are 1-indexed */
	   if (!xnIsPixelFormatSupported (instance->handle, i+1)) continue;
	   lv [lc] = Tcl_NewStringObj (kinetcl_pixelformat [i],-1);
	   lc++;
       }

	Tcl_SetObjResult (interp, Tcl_NewListObj (lc, lv));
	return TCL_OK;
    }

    mdef format { /* Syntax: <instance> format ?format? */
	XnStatus        s;
	XnPixelFormat  	f;

	if (objc == 2) { /* Syntax: <instance> format */
	    f = xnGetPixelFormat (instance->handle);
	    if (f == (XnPixelFormat) -1) {
		Tcl_AppendResult (interp, "Inheritance error: Not an image generator", NULL);
		return TCL_ERROR;
	    }

	    /* array is 0-indexed, pixelformat f is 1-indexed */
	    Tcl_SetObjResult (interp, Tcl_NewStringObj (kinetcl_pixelformat [f-1],-1));
	    return TCL_OK;
	}

	if (objc == 5) { /* Syntax: <instance> format <format> */
	    int pf;
	    if (Tcl_GetIndexFromObj (interp, objv[2], 
				     kinetcl_pixelformat,
				     "pixelformat", 0, &pf) != TCL_OK) {
		return TCL_ERROR;
	    }

	    /* pf is 0-indexed, pixelformats are 1-indexed */
	    s = xnSetPixelFormat (instance->handle, pf+1);
	    CHECK_STATUS_RETURN;

	    return TCL_OK;
	}

	Tcl_WrongNumArgs (interp, 2, objv, "?format?");
	return TCL_ERROR;
    }

    mdef meta { /* Syntax: <instance> meta */
	XnImageMetaData* meta;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	meta = xnAllocateImageMetaData ();

	xnGetImageMetaData (instance->handle, meta);
	Tcl_SetObjResult (interp, kinetcl_convert_image_metadata (meta));

	xnFreeImageMetaData (meta);
	return TCL_OK;
    }

    mdef map { /* Syntax: <instance> map */
	crimp_image* image;
	XnImageMetaData* meta;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	meta = xnAllocateImageMetaData ();
	xnGetImageMetaData (instance->handle, meta);

	switch (meta->pMap->PixelFormat) {
	case XN_PIXEL_FORMAT_RGB24:
	    image = crimp_new_rgb (meta->pMap->Res.X, meta->pMap->Res.Y);
	    break;
	case XN_PIXEL_FORMAT_GRAYSCALE_8_BIT:
	    image = crimp_new_grey8 (meta->pMap->Res.X, meta->pMap->Res.Y);
	    break;
	case XN_PIXEL_FORMAT_GRAYSCALE_16_BIT:
	    image = crimp_new_grey16 (meta->pMap->Res.X, meta->pMap->Res.Y);
	    break;
	case XN_PIXEL_FORMAT_YUV422:
	case XN_PIXEL_FORMAT_MJPEG:
	    xnFreeImageMetaData (meta);
	    Tcl_AppendResult (interp,
			      "Unable to retrieve map in unsupported image format \"",
			      /* array is 0-indexed, pixelformats are 1-indexed */
			      kinetcl_pixelformat [meta->pMap->PixelFormat-1],
			      "\"", NULL);
	    return TCL_ERROR;
	}

	kinetcl_fill_image (image, meta->pData, meta->pMap->pOutput->nDataSize);

	xnFreeImageMetaData (meta);

	Tcl_SetObjResult (interp, crimp_new_image_obj (image));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    ::kt_callback pixelformat \
	xnRegisterToPixelFormatChange \
	xnUnregisterFromPixelFormatChange \
	{} {}

    # # ## ### ##### ######## #############

    support {
	static Tcl_Obj*
	kinetcl_convert_image_metadata (XnImageMetaData* meta)
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
