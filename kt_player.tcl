
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

    method @speed: proc {double speed} XnStatus {
	return xnSetPlaybackSpeed (instance->handle, speed);
    }

    # # ## ### ##### ######## #############

    method repeat proc {bool repeat} XnStatus {
	return xnSetPlayerRepeat (instance->handle, repeat);
    }

    method eof proc {} bool {
	return xnIsPlayerAtEOF (instance->handle);
    }

    method format proc {} {const char*} {
	return xnGetPlayerSupportedFormat (instance->handle);
    }

    method next proc {} XnStatus {
	return xnPlayerReadNext (instance->handle);
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
