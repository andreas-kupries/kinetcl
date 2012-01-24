
# # ## ### ##### ######## #############
## Gesture Generator

critcl::class def kinetcl::gesture {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI gesture generator object}

    constructor {
	kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The gesture generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain gesture generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateGestureGenerator (c->context, &h, NULL, NULL);
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
