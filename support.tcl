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

	classvar kinetcl_context_data context    {Global kinetcl context, shared by all}
	classvar XnContext*           onicontext {Global OpenNI context, shared by all}
	# # ## ### ##### ######## #############

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
    }
}

proc kt_abstract_class {{construction {}} {destruction {}}} {
    uplevel 1 [string map [list \
			       @@construction@@ $construction \
			       @@destruction@@  $destruction \
			      ] {
	::kt_class_common
	# # ## ### ##### ######## #############

	field kinetcl_context_data     context    {Global kinetcl context, shared by all}
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

@@construction@@
	}

	# # ## ### ##### ######## #############
	destructor {
@@destruction@@
	    xnProductionNodeRelease (instance->handle);
	}

	# # ## ### ##### ######## #############
      }]
}

proc kt_node_class {construction {destruction {}}} {
    uplevel 1 [string map [list \
			       @@construction@@ $construction \
			       @@destruction@@  $destruction \
			      ] {
	::kt_class_common
	# # ## ### ##### ######## #############

	field kinetcl_context_data context    {Global kinetcl context, shared by all}
	field XnContext*           onicontext {Global OpenNI context, shared by all}
	# # ## ### ##### ######## #############

	field XnNodeHandle     handle     {Our handle of the OpenNI player object}

	# # ## ### ##### ######## #############
	constructor {
	    XnStatus     s; /* Status of various OpenNI operations */
	    XnNodeHandle h; /* The player's object handle */

	    instance->context    = instance->class->context;
	    instance->onicontext = instance->class->onicontext;

@@construction@@

	    CHECK_STATUS_GOTO;

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

proc kt_callback {name consfunction destfunction signature body} {
    set cname     [string totitle $name]
    set signature [join [list {XnNodeHandle h} {*}$signature {void* clientData}] {, }]

    lappend map @@cname@@         $cname 
    lappend map @@name@@          $name
    lappend map @@consfunction@@  $consfunction
    lappend map @@destfunction@@  $destfunction
    lappend map @@signature@@     $signature
    lappend map @@body@@          $body

    uplevel 1 [string map $map {
	catch {
	    field Tcl_Interp* interp {Interpreter in callback handlers}
	    constructor {
		instance->interp = interp;
	    }
	    destructor {
		/* instance->interp is a non-owned copy, nothing to do */
	    }
	}

	field XnCallbackHandle callback@@cname@@ {Handle for @@name@@ callbacks}
	field Tcl_Obj*         command@@cname@@  {Command prefix for @@name@@ callbacks}

	constructor {
	    instance->callback@@cname@@ = NULL;
	    instance->command@@cname@@ = NULL;
	}

	destructor {
	    @stem@_callback_@@cname@@_unset (instance);
	}

	mdef set-callback-@@name@@ { /* Syntax: <instance> set-callback-@@name@@ <cmd>... */
	    if (objc < 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "cmd...");
		return TCL_ERROR;
	    }

	    return @stem@_callback_@@cname@@_set (instance, objc-2, objv+2);
	}

	mdef unset-callback-@@name@@ { /* Syntax: <instance> unset-callback-@@name@@ */
	    if (objc != 2) {
		Tcl_WrongNumArgs (interp, 2, objv, NULL);
		return TCL_OK;
	    }

	    @stem@_callback_@@cname@@_unset (instance);
	    return TCL_ERROR;
	}

	support {
	    static void
	    @stem@_callback_@@cname@@_handler (@@signature@@)
	    {
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		@instancetype@ instance = (@instancetype@) clientData;
		Tcl_Interp* interp = instance->interp;
		/* ASSERT (h == instance->handle) ? */

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cname@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@name@@", -1));

		{ @@body@@ }

		/* Invoke "{*}$cmdprefix $self @@name@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
	    }

	    static void
	    @stem@_callback_@@cname@@_unset (@instancetype@ instance)
	    {
		if (!instance->callback@@cname@@) return;

		@@destfunction@@ (instance->handle, instance->callback@@cname@@);

		Tcl_DecrRefCount (instance->command@@cname@@);
		instance->callback@@cname@@ = NULL;
		instance->command@@cname@@ = NULL;
	    }

	    static int
	    @stem@_callback_@@cname@@_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	    {
		Tcl_Obj* cmd;
		XnCallbackHandle callback;
		XnStatus s;
		Tcl_Interp* interp = instance->interp;

		s = @@consfunction@@ (instance->handle,
				      @stem@_callback_@@cname@@_handler,
				      instance,
				      &callback);
		CHECK_STATUS_RETURN;

		@stem@_callback_@@cname@@_unset (instance);

		instance->callback@@cname@@ = callback;
		instance->command@@cname@@  = Tcl_NewListObj (objc, objv);
		return TCL_OK;
	    }
	}
    }]
}

# # ## ### ##### ######## #############

proc kt_2callback {name consfunction destfunction namea signaturea bodya nameb signatureb bodyb} {
    set cname     [string totitle $name]

    set cnamea     [string totitle $namea]
    set signaturea [join [list {XnNodeHandle h} {*}$signaturea {void* clientData}] {, }]

    set cnameb     [string totitle $nameb]
    set signatureb [join [list {XnNodeHandle h} {*}$signatureb {void* clientData}] {, }]

    lappend map @@name@@          $name
    lappend map @@cname@@         $cname
    lappend map @@consfunction@@  $consfunction
    lappend map @@destfunction@@  $destfunction

    lappend map @@cnamea@@        $cnamea
    lappend map @@namea@@         $namea
    lappend map @@signaturea@@    $signaturea
    lappend map @@bodya@@         $bodya

    lappend map @@cnameb@@        $cnameb
    lappend map @@nameb@@         $nameb
    lappend map @@signatureb@@    $signatureb
    lappend map @@bodyb@@         $bodyb

    uplevel 1 [string map $map {
	catch {
	    field Tcl_Interp* interp {Interpreter in callback handlers}
	    constructor {
		instance->interp = interp;
	    }
	    destructor {
		/* instance->interp is a non-owned copy, nothing to do */
	    }
	}

	field XnCallbackHandle callback@@cname@@ {Handle for @@name@@ callbacks}
	field Tcl_Obj*         command@@cnamea@@ {Command prefix for @@namea@@ callbacks (@@name@@ aspect)}
	field Tcl_Obj*         command@@cnameb@@ {Command prefix for @@nameb@@ callbacks (@@name@@ aspect)}

	constructor {
	    instance->callback@@cname@@ = NULL;
	    instance->command@@cnamea@@ = NULL;
	    instance->command@@cnameb@@ = NULL;
	}

	destructor {
	    @stem@_callback_@@cnamea@@_unset (instance);
	    @stem@_callback_@@cnameb@@_unset (instance);
	}

	mdef set-callback-@@namea@@ { /* Syntax: <instance> set-callback-@@namea@@ <cmd>... */
	    if (objc < 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "cmd...");
		return TCL_ERROR;
	    }

	    return @stem@_callback_@@cnamea@@_set (instance, objc-2, objv+2);
	}

	mdef unset-callback-@@namea@@ { /* Syntax: <instance> unset-callback-@@namea@@ */
	    if (objc != 2) {
		Tcl_WrongNumArgs (interp, 2, objv, NULL);
		return TCL_OK;
	    }

	    @stem@_callback_@@cnamea@@_unset (instance);
	    return TCL_ERROR;
	}

	mdef set-callback-@@nameb@@ { /* Syntax: <instance> set-callback-@@nameb@@ <cmd>... */
	    if (objc < 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "cmd...");
		return TCL_ERROR;
	    }

	    return @stem@_callback_@@cnameb@@_set (instance, objc-2, objv+2);
	}

	mdef unset-callback-@@nameb@@ { /* Syntax: <instance> unset-callback-@@nameb@@ */
	    if (objc != 2) {
		Tcl_WrongNumArgs (interp, 2, objv, NULL);
		return TCL_OK;
	    }

	    @stem@_callback_@@cnameb@@_unset (instance);
	    return TCL_ERROR;
	}

	support {
	    static void
	    @stem@_callback_@@cnamea@@_handler (@@signaturea@@)
	    {
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		@instancetype@ instance = (@instancetype@) clientData;
		Tcl_Interp* interp = instance->interp;
		/* ASSERT (h == instance->handle) ? */

		/* Ignore callback @@namea@@ if not set */
		if (!instance->command@@cnamea@@) return;

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cnamea@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@namea@@", -1));

		{ @@bodya@@ }

		/* Invoke "{*}$cmdprefix $self @@namea@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
	    }

	    static void
	    @stem@_callback_@@cnameb@@_handler (@@signatureb@@)
	    {
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		@instancetype@ instance = (@instancetype@) clientData;
		Tcl_Interp* interp = instance->interp;
		/* ASSERT (h == instance->handle) ? */

		/* Ignore callback @@nameb@@ if not set */
		if (!instance->command@@cnameb@@) return;

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cnameb@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@nameb@@", -1));

		{ @@bodyb@@ }

		/* Invoke "{*}$cmdprefix $self @@nameb@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
	    }

	    static void
	    @stem@_callback_@@cnamea@@_unset (@instancetype@ instance)
	    {
		/* Single callback handle for 2 callbacks */
		if (!instance->callback@@cname@@) return;

		Tcl_DecrRefCount (instance->command@@cnamea@@);
		instance->command@@cnamea@@ = NULL;

		/* Keep C callback if other Tcl callback still active */
		if (instance->command@@cnameb@@) return;

		@@destfunction@@ (instance->handle, instance->callback@@cname@@);
		instance->callback@@cname@@ = NULL;
	    }

	    static void
	    @stem@_callback_@@cnameb@@_unset (@instancetype@ instance)
	    {
		/* Single callback handle for 2 callbacks */
		if (!instance->callback@@cname@@) return;

		Tcl_DecrRefCount (instance->command@@cnameb@@);
		instance->command@@cnameb@@ = NULL;

		/* Keep C callback if other Tcl callback still active */
		if (instance->command@@cnamea@@) return;

		@@destfunction@@ (instance->handle, instance->callback@@cname@@);
		instance->callback@@cname@@ = NULL;
	    }


	    static int
	    @stem@_callback_@@cnamea@@_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	    {
		Tcl_Obj* cmd;

		if (!instance->callback@@cname@@) {
		    Tcl_Interp* interp = instance->interp;
		    XnCallbackHandle callback;
		    XnStatus s;

		    s = @@consfunction@@ (instance->handle,
					  @stem@_callback_@@cnamea@@_handler,
					  @stem@_callback_@@cnameb@@_handler,
					  instance,
					  &callback);
		    CHECK_STATUS_RETURN;

		    instance->callback@@cname@@ = callback;
		}

		@stem@_callback_@@cnamea@@_unset (instance);
		instance->command@@cnamea@@ = Tcl_NewListObj (objc, objv);
		return TCL_OK;
	    }

	    static int
	    @stem@_callback_@@cnameb@@_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	    {
		Tcl_Obj* cmd;

		if (!instance->callback@@cname@@) {
		    Tcl_Interp* interp = instance->interp;
		    XnCallbackHandle callback;
		    XnStatus s;

		    s = @@consfunction@@ (instance->handle,
					  @stem@_callback_@@cnamea@@_handler,
					  @stem@_callback_@@cnameb@@_handler,
					  instance,
					  &callback);
		    CHECK_STATUS_RETURN;

		    instance->callback@@cname@@ = callback;
		}

		@stem@_callback_@@cnameb@@_unset (instance);
		instance->command@@cnameb@@ = Tcl_NewListObj (objc, objv);
		return TCL_OK;
	    }
	}
    }]
}

# # ## ### ##### ######## #############

proc kt_3callback {name consfunction destfunction
		   namea signaturea bodya
		   nameb signatureb bodyb
		   namec signaturec bodyc
	       } {
    set cname     [string totitle $name]

    set cnamea     [string totitle $namea]
    set signaturea [join [list {XnNodeHandle h} {*}$signaturea {void* clientData}] {, }]

    set cnameb     [string totitle $nameb]
    set signatureb [join [list {XnNodeHandle h} {*}$signatureb {void* clientData}] {, }]

    set cnamec     [string totitle $namec]
    set signaturec [join [list {XnNodeHandle h} {*}$signaturec {void* clientData}] {, }]

    lappend map @@name@@          $name
    lappend map @@cname@@         $cname
    lappend map @@consfunction@@  $consfunction
    lappend map @@destfunction@@  $destfunction

    lappend map @@cnamea@@        $cnamea
    lappend map @@namea@@         $namea
    lappend map @@signaturea@@    $signaturea
    lappend map @@bodya@@         $bodya

    lappend map @@cnameb@@        $cnameb
    lappend map @@nameb@@         $nameb
    lappend map @@signatureb@@    $signatureb
    lappend map @@bodyb@@         $bodyb

    lappend map @@cnamec@@        $cnamec
    lappend map @@namec@@         $namec
    lappend map @@signaturec@@    $signaturec
    lappend map @@bodyc@@         $bodyc

    uplevel 1 [string map $map {
	catch {
	    field Tcl_Interp* interp {Interpreter in callback handlers}
	    constructor {
		instance->interp = interp;
	    }
	    destructor {
		/* instance->interp is a non-owned copy, nothing to do */
	    }
	}

	field XnCallbackHandle callback@@cname@@ {Handle for @@name@@ callbacks}
	field Tcl_Obj*         command@@cnamea@@ {Command prefix for @@namea@@ callbacks (@@name@@ aspect)}
	field Tcl_Obj*         command@@cnameb@@ {Command prefix for @@nameb@@ callbacks (@@name@@ aspect)}
	field Tcl_Obj*         command@@cnamec@@ {Command prefix for @@namec@@ callbacks (@@name@@ aspect)}

	constructor {
	    instance->callback@@cname@@ = NULL;
	    instance->command@@cnamea@@ = NULL;
	    instance->command@@cnameb@@ = NULL;
	    instance->command@@cnamec@@ = NULL;
	}

	destructor {
	    @stem@_callback_@@cnamea@@_unset (instance);
	    @stem@_callback_@@cnameb@@_unset (instance);
	    @stem@_callback_@@cnamec@@_unset (instance);
	}

	mdef set-callback-@@namea@@ { /* Syntax: <instance> set-callback-@@namea@@ <cmd>... */
	    if (objc < 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "cmd...");
		return TCL_ERROR;
	    }

	    return @stem@_callback_@@cnamea@@_set (instance, objc-2, objv+2);
	}

	mdef unset-callback-@@namea@@ { /* Syntax: <instance> unset-callback-@@namea@@ */
	    if (objc != 2) {
		Tcl_WrongNumArgs (interp, 2, objv, NULL);
		return TCL_OK;
	    }

	    @stem@_callback_@@cnamea@@_unset (instance);
	    return TCL_ERROR;
	}

	mdef set-callback-@@nameb@@ { /* Syntax: <instance> set-callback-@@nameb@@ <cmd>... */
	    if (objc < 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "cmd...");
		return TCL_ERROR;
	    }

	    return @stem@_callback_@@cnameb@@_set (instance, objc-2, objv+2);
	}

	mdef unset-callback-@@nameb@@ { /* Syntax: <instance> unset-callback-@@nameb@@ */
	    if (objc != 2) {
		Tcl_WrongNumArgs (interp, 2, objv, NULL);
		return TCL_OK;
	    }

	    @stem@_callback_@@cnameb@@_unset (instance);
	    return TCL_ERROR;
	}

	mdef set-callback-@@namec@@ { /* Syntax: <instance> set-callback-@@namec@@ <cmd>... */
	    if (objc < 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "cmd...");
		return TCL_ERROR;
	    }

	    return @stem@_callback_@@cnamec@@_set (instance, objc-2, objv+2);
	}

	mdef unset-callback-@@namec@@ { /* Syntax: <instance> unset-callback-@@namec@@ */
	    if (objc != 2) {
		Tcl_WrongNumArgs (interp, 2, objv, NULL);
		return TCL_OK;
	    }

	    @stem@_callback_@@cnamec@@_unset (instance);
	    return TCL_ERROR;
	}

	support {
	    static void
	    @stem@_callback_@@cnamea@@_handler (@@signaturea@@)
	    {
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		@instancetype@ instance = (@instancetype@) clientData;
		Tcl_Interp* interp = instance->interp;
		/* ASSERT (h == instance->handle) ? */

		/* Ignore callback @@namea@@ if not set */
		if (!instance->command@@cnamea@@) return;

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cnamea@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@namea@@", -1));

		{ @@bodya@@ }

		/* Invoke "{*}$cmdprefix $self @@namea@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
	    }

	    static void
	    @stem@_callback_@@cnameb@@_handler (@@signatureb@@)
	    {
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		Tcl_InterpState saved;
		@instancetype@ instance = (@instancetype@) clientData;
		Tcl_Interp* interp = instance->interp;
		/* ASSERT (h == instance->handle) ? */

		/* Ignore callback @@nameb@@ if not set */
		if (!instance->command@@cnameb@@) return;

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cnameb@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@nameb@@", -1));

		{ @@bodyb@@ }

		/* Invoke "{*}$cmdprefix $self @@nameb@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
	    }

	    static void
	    @stem@_callback_@@cnamec@@_handler (@@signaturec@@)
	    {
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		Tcl_InterpState saved;
		@instancetype@ instance = (@instancetype@) clientData;
		Tcl_Interp* interp = instance->interp;
		/* ASSERT (h == instance->handle) ? */

		/* Ignore callback @@namec@@ if not set */
		if (!instance->command@@cnamec@@) return;

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cnamec@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@namec@@", -1));

		{ @@bodyc@@ }

		/* Invoke "{*}$cmdprefix $self @@namec@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
	    }

	    static void
	    @stem@_callback_@@cnamea@@_unset (@instancetype@ instance)
	    {
		/* Single callback handle for 2 callbacks */
		if (!instance->callback@@cname@@) return;

		Tcl_DecrRefCount (instance->command@@cnamea@@);
		instance->command@@cnamea@@ = NULL;

		/* Keep C callback if other Tcl callbacks still active */
		if (instance->command@@cnameb@@) return;
		if (instance->command@@cnamec@@) return;

		@@destfunction@@ (instance->handle, instance->callback@@cname@@);
		instance->callback@@cname@@ = NULL;
	    }

	    static void
	    @stem@_callback_@@cnameb@@_unset (@instancetype@ instance)
	    {
		/* Single callback handle for 2 callbacks */
		if (!instance->callback@@cname@@) return;

		Tcl_DecrRefCount (instance->command@@cnameb@@);
		instance->command@@cnameb@@ = NULL;

		/* Keep C callback if other Tcl callback still active */
		if (instance->command@@cnamea@@) return;
		if (instance->command@@cnamec@@) return;

		@@destfunction@@ (instance->handle, instance->callback@@cname@@);
		instance->callback@@cname@@ = NULL;
	    }

	    static void
	    @stem@_callback_@@cnamec@@_unset (@instancetype@ instance)
	    {
		/* Single callback handle for 2 callbacks */
		if (!instance->callback@@cname@@) return;

		Tcl_DecrRefCount (instance->command@@cnamec@@);
		instance->command@@cnamec@@ = NULL;

		/* Keep C callback if other Tcl callback still active */
		if (instance->command@@cnamea@@) return;
		if (instance->command@@cnameb@@) return;

		@@destfunction@@ (instance->handle, instance->callback@@cname@@);
		instance->callback@@cname@@ = NULL;
	    }


	    static int
	    @stem@_callback_@@cnamea@@_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	    {
		Tcl_Obj* cmd;

		if (!instance->callback@@cname@@) {
		    Tcl_Interp* interp = instance->interp;
		    XnCallbackHandle callback;
		    XnStatus s;

		    s = @@consfunction@@ (instance->handle,
					  @stem@_callback_@@cnamea@@_handler,
					  @stem@_callback_@@cnameb@@_handler,
					  @stem@_callback_@@cnamec@@_handler,
					  instance,
					  &callback);
		    CHECK_STATUS_RETURN;

		    instance->callback@@cname@@ = callback;
		}

		@stem@_callback_@@cnamea@@_unset (instance);
		instance->command@@cnamea@@ = Tcl_NewListObj (objc, objv);
		return TCL_OK;
	    }

	    static int
	    @stem@_callback_@@cnameb@@_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	    {
		Tcl_Obj* cmd;

		if (!instance->callback@@cname@@) {
		    Tcl_Interp* interp = instance->interp;
		    XnCallbackHandle callback;
		    XnStatus s;

		    s = @@consfunction@@ (instance->handle,
					  @stem@_callback_@@cnamea@@_handler,
					  @stem@_callback_@@cnameb@@_handler,
					  @stem@_callback_@@cnamec@@_handler,
					  instance,
					  &callback);
		    CHECK_STATUS_RETURN;

		    instance->callback@@cname@@ = callback;
		}

		@stem@_callback_@@cnameb@@_unset (instance);
		instance->command@@cnameb@@ = Tcl_NewListObj (objc, objv);
		return TCL_OK;
	    }

	    static int
	    @stem@_callback_@@cnamec@@_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	    {
		Tcl_Obj* cmd;

		if (!instance->callback@@cname@@) {
		    Tcl_Interp* interp = instance->interp;
		    XnCallbackHandle callback;
		    XnStatus s;

		    s = @@consfunction@@ (instance->handle,
					  @stem@_callback_@@cnamea@@_handler,
					  @stem@_callback_@@cnameb@@_handler,
					  @stem@_callback_@@cnamec@@_handler,
					  instance,
					  &callback);
		    CHECK_STATUS_RETURN;

		    instance->callback@@cname@@ = callback;
		}

		@stem@_callback_@@cnamec@@_unset (instance);
		instance->command@@cnamec@@ = Tcl_NewListObj (objc, objv);
		return TCL_OK;
	    }
	}
    }]
}

# # ## ### ##### ######## #############

critcl::ccode {
    static void
    kinetcl_invoke_callback (Tcl_Interp* interp, Tcl_Obj* cmd)
    {
	int res;
	Tcl_InterpState saved;

	Tcl_Preserve (interp);
	saved = Tcl_SaveInterpState (interp, TCL_OK);

	res = Tcl_GlobalEvalObj (interp, cmd);

	Tcl_RestoreInterpState (interp, saved);
	Tcl_Release (interp);
	Tcl_DecrRefCount (cmd);
    }
}

# # ## ### ##### ######## #############
return
