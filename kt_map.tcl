# # ## ### ##### ######## #############
## Map Generator Base Class -> generator

critcl::class def ::kinetcl::Map {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method bytes-per-pixel proc {} int {
	return xnGetBytesPerPixel (instance->handle);
    }

    method modes proc {} ok {
	XnStatus s;
	int lc;
	Tcl_Obj** lv = NULL;
	XnMapOutputMode* modes;

	lc = xnGetSupportedMapOutputModesCount (instance->handle);
	if (lc) {
	    int i;

	    modes = (XnMapOutputMode*) ckalloc (lc * sizeof (XnMapOutputMode));
	    s = xnGetSupportedMapOutputModes (instance->handle, modes, &lc);
	    CHECK_STATUS_GOTO;

	    lv = (Tcl_Obj**) ckalloc (lc * sizeof (Tcl_Obj*));
	    for (i = 0;
		 i < lc;
		 i++) {
	       Tcl_Obj* mv [3];
	       mv [0] = Tcl_NewIntObj (modes [i].nXRes);
	       mv [1] = Tcl_NewIntObj (modes [i].nYRes);
	       mv [2] = Tcl_NewIntObj (modes [i].nFPS);
	       lv [i] = Tcl_NewListObj (3, mv);
	    }

	    ckfree ((char*) modes);
	}

	Tcl_SetObjResult (interp, Tcl_NewListObj (lc, lv));

	if (lc) {
	    ckfree ((char*) lv);
	}

	return TCL_OK;
    error:
	ckfree ((char*) modes);
	return TCL_ERROR;
    }

    # # ## ### ##### ######## #############

    method @mode? proc {} ok {
	XnStatus        s;
	XnMapOutputMode mode;
	Tcl_Obj* mv [3];

	s = xnGetMapOutputMode (instance->handle, &mode);
	CHECK_STATUS_RETURN;

	mv [0] = Tcl_NewIntObj (mode.nXRes);
	mv [1] = Tcl_NewIntObj (mode.nYRes);
	mv [2] = Tcl_NewIntObj (mode.nFPS);

	Tcl_SetObjResult (interp, Tcl_NewListObj (3, mv));
	return TCL_OK;
    }

    method @mode: {int xres int yres int fps} XnStatus {
	XnMapOutputMode mode;

	mode.nXRes = xres;
	mode.nYRes = yres;
	mode.nFPS  = fps;

	return xnSetMapOutputMode (instance->handle, &mode);
    }

    # # ## ### ##### ######## #############
    ## Callbacks: output mode change

    ::kt_callback mode \
	xnRegisterToMapOutputModeChange \
	xnUnregisterFromMapOutputModeChange \
	{} {}

    # # ## ### ##### ######## #############

    support {
	#define kinetcl_NUM_PIXELFORMATS (5)

	/* NOTE !!
	 * The XnPixelFormat enum starts counting at 1, this array is
	 * 0-indexed however. Take care in indexing.
	 */

	static const char* kinetcl_pixelformat [] = {
	    "rgb24",  /* XN_PIXEL_FORMAT_RGB24 	          */
	    "yuv422", /* XN_PIXEL_FORMAT_YUV422 	  */
	    "grey8",  /* XN_PIXEL_FORMAT_GRAYSCALE_8_BIT  */
	    "grey16", /* XN_PIXEL_FORMAT_GRAYSCALE_16_BIT */
	    "mjpeg",  /* XN_PIXEL_FORMAT_MJPEG 	          */
	    NULL
	};

	static Tcl_Obj*
	kinetcl_convert_map_metadata (XnMapMetaData* meta)
	{
	    Tcl_Obj* res = Tcl_NewDictObj ();
	    Tcl_Obj* pair [2];

	    pair [0] = Tcl_NewIntObj (meta->Res.X);
	    pair [1] = Tcl_NewIntObj (meta->Res.Y);
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("res",-1),
			    Tcl_NewListObj (2, pair));

	    pair [0] = Tcl_NewIntObj (meta->Offset.X);
	    pair [1] = Tcl_NewIntObj (meta->Offset.Y);
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("offset",-1),
			    Tcl_NewListObj (2, pair));

	    pair [0] = Tcl_NewIntObj (meta->FullRes.X);
	    pair [1] = Tcl_NewIntObj (meta->FullRes.Y);
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("fullres",-1),
			    Tcl_NewListObj (2, pair));

	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("format",-1),
			    /* array is 0-indexed, pixelformats are 1-indexed */
			    Tcl_NewStringObj (kinetcl_pixelformat [meta->PixelFormat-1],-1));
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("fps",-1),
			    Tcl_NewIntObj (meta->nFPS));
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("output",-1),
			    kinetcl_convert_output_metadata (meta->pOutput));
	    return res;
	}
    }

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
