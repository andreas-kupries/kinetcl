
# # ## ### ##### ######## #############
## Player

critcl::class def kinetcl::player {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI player object}

    constructor {
	kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The player's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain player object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreatePlayer (c->context, "oni", &h);
	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}
