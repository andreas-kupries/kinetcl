## -*- tcl -*-
# # ## ### ##### ######## #############

## ATTENTION. This file contains '# line' directives for embedded C
## code, with hardwired line numbers. Please check and edit these
## directives for correctness after editing this file.

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we provide setup of common constructions found in and shared
## by the C classes. Common instance variables, their construction,
## etc.

# # ## ### ##### ######## #############

proc kt_class_common {} {

    method_introspection

    # auto instance method 'methods'.
    # auto classvar 'methods'
    # auto field    'class'
    # auto instance method 'destroy'.

    include XnOpenNI.h
    # # ## ### ##### ######## #############

    classvariable kinetcl_context_data context {
	Global kinetcl context, shared among all classes and instances.
    }

    classvariable XnContext* onicontext {
	Global OpenNI context, shared among all classes and instances.
    }

    # XXX See if this can be put into the classvariable constructors.
    classconstructor {
	kinetcl_context_data c; /* The package's global (per-interp) data */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp);
	if (!c) {
	    goto error;
	}

	class->context    = c;
	class->onicontext = c->context;
    }

    # # ## ### ##### ######## #############

    insvariable kinetcl_context_data context {
	Global kinetcl context, shared by all instances, provided by the class.
    } {
	instance->context = instance->class->context;
    } {
	instance->context = NULL;
    }

    insvariable XnContext* onicontext {
	Global OpenNI context, shared by all instances, provided by the class.
    } {
	instance->onicontext = instance->class->onicontext;
    } {
	instance->onicontext = NULL;
    }

    # # ## ### ##### ######## #############
    ## C-level special method. Link the Tcl-level wrapper object
    ## to the C-level instance so that callbacks generated by it
    ## carry the proper instance command.

    insvariable Tcl_Obj* self {
	Fully qualified name of the object itself, for use in callbacks.
	Higher layers can override this information via method @self, i.e.
	are able to set this value to a Tcl object wrapped around this one.
    } {} {
	Tcl_DecrRefCount (instance->self);
    }

    constructor {} {
	instance->self = fqn;
	Tcl_IncrRefCount (instance->self);
    }

    method @self proc {Tcl_Obj* obj} void {
	Tcl_DecrRefCount (instance->self);
	instance->self = obj;
	Tcl_IncrRefCount (instance->self);
    }

    # # ## ### ##### ######## #############
    
}

proc kt_abstract_class {{construction {}} {destruction {}}} {
    critcl::at::caller              ; set cloc [critcl::at::get*]
    critcl::at::incrt $construction ; set dloc [critcl::at::get]

    set map [list \
		 @@construction@@ $cloc$construction \
		 @@destruction@@  $dloc$destruction \
		]

    ::kt_class_common
    # # ## ### ##### ######## #############

    insvariable XnNodeHandle handle {
	Our handle of the OpenNI production object
    } [string map $map {
	/* As an abstract base class we do not create our own
	* XnNodeHandle. It is provided by the concrete leaf class
	* instead. Which is expected to stash the handle into the
	* per-interp structures for us to retrieve from.
	*/
	instance->handle     = instance->context->mark;
	xnProductionNodeAddRef (instance->handle);

	@@construction@@
    }] [string map $map {
	@@destruction@@
	xnProductionNodeRelease (instance->handle);
    }]

    # # ## ### ##### ######## #############
}

proc kt_node_class {construction {destruction {}}} {
    critcl::at::caller              ; set cloc [critcl::at::get*]
    critcl::at::incrt $construction ; set dloc [critcl::at::get]

    set map [list \
		 @@construction@@ $cloc$construction \
		 @@destruction@@  $dloc$destruction \
		]

    ::kt_class_common

    # # ## ### ##### ######## #############
    insvariable XnNodeHandle handle {
	Our handle of the OpenNI object.
    } [string map $map {
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The player's object handle */

	@@construction@@
	# line 152 "support_classes.tcl"
	CHECK_STATUS_GOTO;

	/* Fill our structure */
	instance->handle  = h;

	/* Stash the handle for use by the super-classes. */
	instance->context->mark = h;
    }] [string map $map {
	@@destruction@@
	# line 162 "support_classes.tcl"
	xnProductionNodeRelease (instance->handle);
    }]

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
return
