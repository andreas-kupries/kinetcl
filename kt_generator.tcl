# # ## ### ##### ######## #############
## Generator Base Class -> production

critcl::class def ::kinetcl::Generator {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############
    ## Control and query data generation

    method start proc {} XnStatus {
	return xnStartGenerating (instance->handle);
    }

    method stop proc {} XnStatus {
	return xnStopGenerating (instance->handle);
    }

    method active proc {} bool {
	return xnIsGenerating (instance->handle);
    }

    # # ## ### ##### ######## #############
    ## Wait for data, check if waiting would not block

    method update proc {} XnStatus {
	return xnWaitAndUpdateData (instance->handle);
    }

    method hasNew proc {} bool {
	/* XXX FUTURE: May pull and return timestamp of such new data */
	return xnIsNewDataAvailable (instance->handle, NULL);
    }

    # # ## ### ##### ######## #############
    ## Query data attributes (is it new?, frame id, timestamp)
    ## Note: Data size and data itself are not accessible here, but only is derived classes.

    method proc isNew {} bool {
	return xnIsDataNew (instance->handle);
    }

    method frame proc {} KFrame {
	return xnGetFrameID (instance->handle);
    }

    method time proc {} KTimestamp {
	return xnGetTimestamp (instance->handle);
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
