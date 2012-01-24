
# # ## ### ##### ######## #############
## Hands Generator

critcl::class def kinetcl::hands {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI hands generator object}

    constructor {
	kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The hands generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain hands generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateHandsGenerator (c->context, &h, NULL, NULL);
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
