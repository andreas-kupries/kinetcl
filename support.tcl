## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base, providing setup of common constructions
## found in and shared by the C classes. (Common instance variables,
## their construction, etc.).

# # ## ### ##### ######## #############

proc kt_class_common {} {
    uplevel 1 {
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

	classconstructor {
	    kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	    XnStatus     s; /* Status of various OpenNI operations */

	    /* Get the framework context. Might fail. */
	    c = kinetcl_context (interp, &s);
	    if (!c) {
		Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
		goto error;
	    }

	    class->context    = c;
	    class->onicontext = c->context;
	}

	# # ## ### ##### ######## #############
    }
}

proc kt_abstract_class {} {
    uplevel 1 {
	::kt_class_common
	# # ## ### ##### ######## #############

	field kinetcl_ctx*     context    {Global kinetcl context, shared by all}
	field XnContext*       onicontext {Global OpenNI context, shared by all}
	# # ## ### ##### ######## #############

	field XnNodeHandle     handle     {Our handle of the OpenNI production object}
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
}

proc kt_node_class {construction {destruction {}}} {
    uplevel 1 [string map [list \
			       @@construction@@ $construction \
			       @@destruction@@  $destruction \
			      ] {
	::kt_class_common
	# # ## ### ##### ######## #############

	field kinetcl_ctx*     context    {Global kinetcl context, shared by all}
	field XnContext*       onicontext {Global OpenNI context, shared by all}
	# # ## ### ##### ######## #############

	field XnNodeHandle     handle     {Our handle of the OpenNI player object}

	# # ## ### ##### ######## #############
	constructor {
	    XnStatus     s; /* Status of various OpenNI operations */
	    XnNodeHandle h; /* The player's object handle */

	    instance->context    = instance->class->context;
	    instance->onicontext = instance->class->onicontext;

@@construction@@

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
@@destruction@@
	    xnProductionNodeRelease (instance->handle);
	}

	# # ## ### ##### ######## #############
	mdef @unmark {
	    /* Internal method, no argument checking. */
	    instance->context->mark = NULL;
	    return TCL_OK;
	}

	# # ## ### ##### ######## #############
    }]
}

# # ## ### ##### ######## #############
return
