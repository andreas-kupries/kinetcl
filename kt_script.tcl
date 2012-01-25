
# # ## ### ##### ######## #############
## Script

critcl::class def kinetcl::Script {
    introspect-methods
    # auto instance method 'methods'.
    # auto classvar 'methods'
    # auto field    'class'
    # auto instance method 'destroy'.

    include XnOpenNI.h
    # # ## ### ##### ######## #############

    classvar kinetcl_ctx* context    {Global kinetcl context, shared by all}
    classvar XnContext*   onicontext {Global OpenNI context, shared by all}
    # # ## ### ##### ######## #############

    field kinetcl_ctx*     context    {Global kinetcl context, shared by all}
    field XnContext*       onicontext {Global OpenNI context, shared by all}
    # # ## ### ##### ######## #############

    field XnNodeHandle     handle     {Our handle of the OpenNI script object}
    # # ## ### ##### ######## #############

    classconstructor {
	kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	class->context = c;
	class->onicontext = c->context;
    }

    # # ## ### ##### ######## #############
    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The script's object handle */

	instance->context    = instance->class->context;
	instance->onicontext = instance->class->onicontext;

	/* Create a plain script object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateScriptNode (instance->onicontext, "oni", &h); // XXX TODO: Which script formats exist ?
	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;

	/* Stash for use by the super classes. */
	instance->context->mark = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }

    # # ## ### ##### ######## #############
    mdef @unmark {
	/* Internal method, no argument checking. */
	instance->context->mark = NULL;
	return TCL_OK;
    }
}
