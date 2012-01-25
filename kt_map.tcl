# # ## ### ##### ######## #############
## Map Generator Base Class -> generator

critcl::class def kinetcl::Map {
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

    field XnNodeHandle     handle     {Our handle of the OpenNI map generator object}
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
	/* As an abstract base class it does not create its own
	 * XnNodeHandle, but gets it from the concrete leaf class.
	 * Which is expected to stash the handle in the per-interp
	 * structures.
	 */

	instance->context    = instance->class->context;
	instance->onicontext = instance->class->onicontext;
	instance->handle     = instance->context->mark;
	xnProductionNodeAddRef (instance->handle);
    }

    # # ## ### ##### ######## #############
    destructor {
	xnProductionNodeRelease (instance->handle);
    }

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
