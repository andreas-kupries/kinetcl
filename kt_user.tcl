
# # ## ### ##### ######## #############
## User Generator

critcl::class def ::kinetcl::User {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain user generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateUserGenerator (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############

    method count proc {} int {
	return xnGetNumberOfUsers (instance->handle);
    }

    # # ## ### ##### ######## #############

    method users proc {} ok {
	int i, res = TCL_OK;
	XnUInt16  n;
	XnUserID* id;
	XnStatus  s;
	Tcl_Obj*  ulist;

	n = xnGetNumberOfUsers (instance->handle);
	id = (XnUserID*) ckalloc (n * sizeof (XnUserID));

	s = xnGetUsers (instance->handle, id, &n);
	CHECK_STATUS_RETURN;

	ulist = Tcl_NewListObj (0,NULL);
	for (i=0; i < n; i++) {
            if (Tcl_ListObjAppendElement (interp, ulist, Tcl_NewIntObj (id [i])) != TCL_OK) {
		Tcl_DecrRefCount (ulist);
		goto error;
	    }
	}

	Tcl_SetObjResult (interp, ulist);
	goto done;

      error:
	res = TCL_ERROR;
      done:
	ckfree ((char*) id);
	return res;
    }

    # # ## ### ##### ######## #############

    method centerof proc {int id} ok {
	XnStatus s;
	XnPoint3D p;
	Tcl_Obj* coord [3];

	s = xnGetUserCoM (instance->handle, id, &p);
	CHECK_STATUS_RETURN;

	Tcl_SetObjResult (interp, kinetcl_convert_3d (&p));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    method pixelsof proc {int id} ok {
	XnStatus s;
	crimp_image* image;
	XnSceneMetaData* meta;

	meta = xnAllocateSceneMetaData ();

	s = xnGetUserPixels (instance->handle, id, meta);
	/* CHECK_STATUS_RETURN, inlined, to free the meta data */
	if (s != XN_STATUS_OK) {
	    xnFreeSceneMetaData (meta);
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    return TCL_ERROR;
	}

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

	xnFreeSceneMetaData (meta);

	Tcl_SetObjResult (interp, crimp_new_image_obj (image));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    ## Callbacks: enter, exit, new/lost

    ::kt_callback user-enter \
	xnRegisterToUserReEnter \
	xnUnregisterFromUserReEnter \
	{{XnUserID u}} {
	    CB_DETAIL ("user", Tcl_NewIntObj (u));
	}

    ::kt_callback user-exit \
	xnRegisterToUserExit \
	xnUnregisterFromUserExit \
	{{XnUserID u}} {
	    CB_DETAIL ("user", Tcl_NewIntObj (u));
	}

    ::kt_2callback newlost \
	xnRegisterUserCallbacks \
	xnUnregisterUserCallbacks \
	user-new {{XnUserID u}} {
	    CB_DETAIL ("user", Tcl_NewIntObj (u));
	} \
	user-lost {{XnUserID u}} {
	    CB_DETAIL ("user", Tcl_NewIntObj (u));
	}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
