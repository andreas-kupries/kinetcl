
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

    method formats proc {} Tcl_Obj* {
	int i, lc;
	Tcl_Obj* lv [kinetcl_NUM_PIXELFORMATS];

	for (lc = 0, i = 0;
	     i < kinetcl_NUM_PIXELFORMATS;
	     i++) {
	   /* i, array are 0-indexed, pixelformats are 1-indexed */
	   if (!xnIsPixelFormatSupported (instance->handle, i+1)) continue;
	   lv [lc] = Tcl_NewStringObj (kinetcl_pixelformat [i],-1);
	   lc++;
       }

	return Tcl_NewListObj (lc, lv);
    }

    method @format? proc {} ok {
	XnStatus      s;
	XnPixelFormat f;

	f = xnGetPixelFormat (instance->handle);
	if (f == (XnPixelFormat) -1) {
	    Tcl_AppendResult (interp, "Inheritance error: Not an image generator", NULL);
	    return TCL_ERROR;
	}

	/* array is 0-indexed, pixelformat f is 1-indexed */
	Tcl_SetObjResult (interp, Tcl_NewStringObj (kinetcl_pixelformat [f-1],-1));
	return TCL_OK;
    }

    method @format: proc {Tcl_Obj* format} ok {
	XnStatus s;
	int      pf;

	if (Tcl_GetIndexFromObj (interp, format, 
				 kinetcl_pixelformat,
				 "pixelformat", 0, &pf) != TCL_OK) {
	    return TCL_ERROR;
	}

	/* pf is 0-indexed, pixelformats are 1-indexed */
	s = xnSetPixelFormat (instance->handle, pf+1);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method meta proc {} ok {
	XnImageMetaData* meta;

	meta = xnAllocateImageMetaData ();

	xnGetImageMetaData (instance->handle, meta);
	Tcl_SetObjResult (interp, kinetcl_convert_image_metadata (meta));

	xnFreeImageMetaData (meta);
	return TCL_OK;
    }

    method map proc {} ok {
	crimp_image* image;
	XnImageMetaData* meta;

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

	/* Assert size equivalence */
	if ((SZ (image)*crimp_image_area(image)) != meta->pMap->pOutput->nDataSize) {
	    Tcl_Panic ("raw pixel size mismatch");
	}

	memcpy (image->pixel, meta->pData, meta->pMap->pOutput->nDataSize);

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
