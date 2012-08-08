
# # ## ### ##### ######## #############
## Player

critcl::class def ::kinetcl::Player {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain player object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreatePlayer (instance->onicontext, "oni", &h);
    }

    # # ## ### ##### ######## #############

    method @speed? proc {} double {
	return xnGetPlaybackSpeed (instance->handle);
    }

    method @speed: proc {double speed} ok {
	XnStatus s;

	s = xnSetPlaybackSpeed (instance->handle, speed);
	CHECK_STATUS_RETURN;
	return TCL_OK;
    }

    # # ## ### ##### ######## #############

    method repeat proc {bool repeat} ok {
	XnStatus s;

	s = xnSetPlayerRepeat (instance->handle, repeat);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    method eof proc {} bool {
	return xnIsPlayerAtEOF (instance->handle);
    }

    method format proc {} vstring {
	return xnGetPlayerSupportedFormat (instance->handle);
    }

    method next proc {} ok {
	XnStatus s;

	s = xnPlayerReadNext (instance->handle);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    # XXX enumerate player nodes
    # XXX seek, tell, query frames - player nodes needed.
    # XXX source

    # # ## ### ##### ######## #############
    ## Callbacks: @eof

    ::kt_callback eof \
	xnRegisterToEndOfFileReached \
	xnUnregisterFromEndOfFileReached \
	{} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
