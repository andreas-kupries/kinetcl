# # ## ### ##### ######## #############
## Generator Base Class -> production

critcl::class def ::kinetcl::Generator {
    # # ## ### ##### ######## #############
    ::kt_abstract_class {
    } {
    }

    # # ## ### ##### ######## #############
    ## Control and query data generation

    method start {} {
	XnStatus s;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnStartGenerating (instance->handle);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method stop {} {
	XnStatus s;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnStopGenerating (instance->handle);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method active {} {
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewIntObj (xnIsGenerating (instance->handle)));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    ## Wait for data, check if waiting would not block

    method update {} {
	XnStatus s;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	s = xnWaitAndUpdateData (instance->handle);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method hasNew {} {
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	/* XXX FUTURE: May pull and return timestamp of such new data */
	Tcl_SetObjResult (interp, Tcl_NewIntObj (xnIsNewDataAvailable (instance->handle, NULL)));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    ## Query data attributes (is it new?, frame id, timestamp)
    ## Note: Data size and data itself are not accessible here, but only is derived classes.

    method isNew {} {
	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewIntObj (xnIsDataNew (instance->handle)));
	return TCL_OK;
    }

    method frame {} {
	XnUInt32 frame;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	frame = xnGetFrameID (instance->handle);
	if (frame == ((XnUInt32) -1)) {
	    Tcl_AppendResult (interp, "Inheritance error: Not a generator", NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewIntObj (frame));
	return TCL_OK;
    }

    method time {} {
	XnUInt64 timestamp;

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	timestamp = xnGetTimestamp (instance->handle);
	if (timestamp == ((XnUInt64) -1)) {
	    Tcl_AppendResult (interp, "Inheritance error: Not a generator", NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewWideIntObj (timestamp));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    ## Callbacks: activity change, data update

    ::kt_callback active \
	xnRegisterToGenerationRunningChange \
	xnUnregisterFromGenerationRunningChange \
	{} {}

    ::kt_callback newdata \
	xnRegisterToNewDataAvailable \
	xnUnregisterFromNewDataAvailable \
	{} {} collapsed

    # # ## ### ##### ######## #############
    ## The C level accessor functions cannot be used here, but only in
    ## the concrete classes, as only they know the type of the data,
    ## and how to convert it.
    ##
    ## const void *xnGetData     (XnNodeHandle hInstance)
    #	Gets the current data. (raw bytes).
    #
    ## XnUInt32    xnGetDataSize (XnNodeHandle hInstance)
    #	Gets the size of current data, in bytes. 

    support {
	static Tcl_Obj*
	kinetcl_convert_output_metadata (XnOutputMetaData* meta)
	{
	    Tcl_Obj* res = Tcl_NewDictObj ();

	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("time",-1),
			    Tcl_NewWideIntObj (meta->nTimestamp));
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("frame",-1),
			    Tcl_NewIntObj (meta->nFrameID));
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("size",-1),
			    Tcl_NewIntObj (meta->nDataSize));
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("new",-1),
			    Tcl_NewIntObj (meta->bIsNew));
	    return res;
	}
    }
}

# # ## ### ##### ######## #############
