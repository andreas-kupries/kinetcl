## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines the per-intepreter structures collecting
## information relevant to the whole package, i.e. all classes and
## instances. All classes, and instances will have a reference to this
## structure which is initialized at class and instance construction
## time, via kinetcl_context ().

critcl::ccode {
    #include <XnOpenNI.h>

    /* The OpenNI context is generated on a per-interp basis
     * XXX TODO - This is suitable for encapsulation into a critcl utility package.
     * XXX NOTE - critcl::class uses the same template to manage the counter for
     *            auto-generated instance names.
     */

    typedef struct kinetcl_ctx {
	XnContext* context;
	Tcl_Obj* strNew;
	Tcl_Obj* strLost;

	XnNodeHandle mark; /* This element is used by instances to
	                    * propagate their handle to base classes
	                    * without having to expose the handle/pointer
	                    * to the Tcl level.
	                    */
    } kinetcl_ctx;

    static void
    kinetcl_context_release (ClientData cd, Tcl_Interp* interp)
    {
	kinetcl_ctx* c = (kinetcl_ctx*) cd;

	xnContextRelease (c->context);
	Tcl_DecrRefCount (c->strNew);
	Tcl_DecrRefCount (c->strLost);
    }

    static kinetcl_ctx*
    kinetcl_context (Tcl_Interp* interp, XnStatus* status)
    {
#define KEY "KineTcl/OpenNI/Context"
	Tcl_InterpDeleteProc* proc = kinetcl_context_release;

	kinetcl_ctx* context = (kinetcl_ctx*) Tcl_GetAssocData (interp, KEY, &proc);
	if (!context) {
	    context = (kinetcl_ctx*) ckalloc (sizeof (kinetcl_ctx));

	    *status = xnInit (&context->context);
	    if (*status != XN_STATUS_OK) {
		ckfree ((char*) context);
		return NULL;
	    }
	    context->strNew  = Tcl_NewStringObj ("new",-1);
	    context->strLost = Tcl_NewStringObj ("lost",-1);
	    Tcl_SetAssocData (interp, KEY, proc, (ClientData) context);
	}

	return context;
#undef KEY
    }


#define CHECK_STATUS_RETURN \
	if (s != XN_STATUS_OK) { \
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL); \
	    return TCL_ERROR; \
	}

#define CHECK_STATUS_GOTO \
	if (s != XN_STATUS_OK) { \
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL); \
	    goto error; \
	}
}
