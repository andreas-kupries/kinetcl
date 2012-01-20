# -*- tcl -*-
# KineTcl = A Tcl Binding for MS Kinect, based on the OpenNI framework
#
# (c) 2012 Andreas Kupries http://wiki.tcl.tk/andreas%20kupries
#

# # ## ### ##### ######## #############
## Requisites

package require critcl 3.1
critcl::buildrequirement {
    package require critcl::util 1
    package require critcl::class 1
}

# # ## ### ##### ######## #############

if {![critcl::compiling]} {
    error "Unable to build KineTcl, no proper compiler found."
}

# # ## ### ##### ######## #############
## Administrivia

critcl::license \
    {Andreas Kupries} \
    {Under a BSD license.}

critcl::summary \
    {OpenNI based Tcl binding to Kinect and similar sensor systems}

critcl::description {
    This package provides access to Kinect and similar sensor system,
    through binding to the OpenNI framework.
}

critcl::subject kinect primesense oenni nite game

# # ## ### ##### ######## #############
## Implementation.

critcl::tcl 8.5

# # ## ### ##### ######## #############
## Declarations and linkage of the OpenNI framework we are binding to.

critcl::cheaders   -I/usr/include/ni ; # XXX TODO automatic search/configuration
critcl::clibraries -lOpenNI

# # ## ### ##### ######## #############
## Declare the Tcl layer aggregating the C primitives into useful
## commands.

critcl::tsources policy.tcl

# # ## ### ##### ######## #############
## Main C section.

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
}

# # ## ### ##### ######## #############
## Classes for the various types of objects.

# # ## ### ##### ######## #############
## Depth Generator

critcl::class def kinetcl::depth {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI depth generator object}

    constructor {
	kinetcl_ctx* c; /* The package's context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The depth generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain depth generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateDepthGenerator (c->context, &h, NULL, NULL);
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

# # ## ### ##### ######## #############
## Image Generator

critcl::class def kinetcl::image {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI image generator object}

    constructor {
	kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The image generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain image generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateImageGenerator (c->context, &h, NULL, NULL);
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

# # ## ### ##### ######## #############
## IR (image) Generator

critcl::class def kinetcl::ir {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI IR generator object}

    constructor {
	kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The IR generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain ir generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateIRGenerator (c->context, &h, NULL, NULL);
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

# # ## ### ##### ######## #############
## Scene Analyzer

critcl::class def kinetcl::scene {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI scene analyzer object}

    constructor {
	kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The scene analyzer's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain scene analyzer object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateSceneAnalyzer (c->context, &h, NULL, NULL);
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

# # ## ### ##### ######## #############
## User Generator

critcl::class def kinetcl::user {
    include XnOpenNI.h

    field XnNodeHandle     handle    {Our handle of the OpenNI user tracker object}
    field Tcl_Interp*      interp    {Interpreter for the callbacks}

    field XnCallbackHandle onExit    {Handle for exit callbacks, if any}
    field XnCallbackHandle onEnter   {Handle for enter callbacks, if any}
    field XnCallbackHandle onNewLost {Handle for New/Lost callbacks, if any}

    field Tcl_Obj* cmdExit    {And associated command prefixes}
    field Tcl_Obj* cmdEnter
    field Tcl_Obj* cmdNewLost

    # auto method 'destroy'.

    # # ## ### ##### ######## #############
    constructor {
	kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The user tracker's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain user generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateUserGenerator (c->context, &h, NULL, NULL);
	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle = h;
	instance->interp = interp;

	/* No callbacks at the beginning */
	instance->onExit    = NULL;
	instance->onEnter   = NULL;
	instance->onNewLost = NULL;

	instance->cmdExit    = NULL;
	instance->cmdEnter   = NULL;
	instance->cmdNewLost = NULL;
    }

    # # ## ### ##### ######## #############
    destructor {
	/* instance->interp is non-owned copy, nothing to do */
	kinetcl_user_exit_unset (instance);
	kinetcl_user_enter_unset (instance);
	kinetcl_user_newlost_unset (instance);
	xnProductionNodeRelease (instance->handle);
    }

    # # ## ### ##### ######## #############
    mdef count {
	/* Syntax: users */
	if (objc != 1) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	Tcl_SetObjResult (interp, Tcl_NewIntObj (xnGetNumberOfUsers (instance->handle)));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    mdef users {
	/* Syntax: users */

	int i, res = TCL_OK;
	XnUInt16  n;
	XnUserID* id;
	XnStatus  s;
	Tcl_Obj*  ulist;

	if (objc != 1) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	n = xnGetNumberOfUsers (instance->handle);
	id = (XnUserID*) ckalloc (n * sizeof (XnUserID));

	s = xnGetUsers (instance->handle, id, &n);
	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	ulist = Tcl_NewListObj (0,NULL);
	for (i=0; i < n; i++) {
            if (Tcl_ListObjAppendElement (interp, ulist, Tcl_NewIntObj (id [i])) != TCL_OK) {
		Tcl_DecrRefCount (ulist);
		goto error;
	    }
	}

	Tcl_SetObjResult (interp, ulist);
	goto done;

      error:
	res = TCL_ERROR;
      done:
	ckfree ((char*) id);
	return res;
    }

    # # ## ### ##### ######## #############
    mdef centerof {
	/* Syntax: centerof <id> */
	int id;
	XnStatus s;
	XnPoint3D p;
	Tcl_Obj* coord [3];

	if (objc != 2) {
	    Tcl_WrongNumArgs (interp, 2, objv, NULL);
	    return TCL_ERROR;
	}

	if (Tcl_GetIntFromObj (interp, objv[1], &id) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnGetUserCoM (instance->handle, id, &p);
	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    return TCL_ERROR;
	}

	coord [0] = Tcl_NewIntObj (p.X);
	coord [1] = Tcl_NewIntObj (p.Y);
	coord [2] = Tcl_NewIntObj (p.Z);
	Tcl_SetObjResult (interp, Tcl_NewListObj (3, coord));
	return TCL_OK;
    }

    # # ## ### ##### ######## #############
    # mdef pixelsof {} : TODO - Requires CRIMP (image).


    # # ## ### ##### ######## #############
    mdef onEnter {
	/* Syntax: onenter ?<cmd> ?<arg>...?? */

	if (objc == 1) {
	    kinetcl_user_enter_unset (instance);
	    return TCL_OK;
	} else {
	    return kinetcl_user_enter_set (instance, objc-1, objv+1);
	}
    }

    mdef onExit {
	/* Syntax: onexit ?<cmd> ?<arg>...?? */

	if (objc == 1) {
	    kinetcl_user_exit_unset (instance);
	    return TCL_OK;
	} else {
	    return kinetcl_user_exit_set (instance, objc-1, objv+1);
	}
    }

    mdef onNewOrLost {
	/* Syntax: onnew-or-lost ?<cmd> ?<arg>...?? */

	if (objc == 1) {
	    kinetcl_user_newlost_unset (instance);
	    return TCL_OK;
	} else {
	    return kinetcl_user_newlost_set (instance, objc-1, objv+1);
	}
    }

    # # ## ### ##### ######## #############
    support {
	/* ======================================================================= */
	static void
	kinetcl_user_exit_handle (XnNodeHandle h, XnUserID u, void* clientData)
	{
	    int res;
	    Tcl_Obj* cmd;
	    Tcl_Obj* self;
	    @instancetype@ instance = (@instancetype@) clientData;
	    /* ASSERT (h == instance->handle) ? */

	    self = Tcl_NewObj ();
	    Tcl_GetCommandFullName (instance->interp, instance->cmd, self);

	    cmd = Tcl_DuplicateObj (instance->cmdExit);
	    Tcl_ListObjAppendElement (instance->interp, cmd, self);
	    Tcl_ListObjAppendElement (instance->interp, cmd, Tcl_NewIntObj (u));

	    /* Invoke "{*}$cmdprefix $self $userid" */
	    res = Tcl_GlobalEvalObj (instance->interp, cmd);

	    Tcl_DecrRefCount (cmd);
	}

	static void
	kinetcl_user_exit_unset (@instancetype@ instance)
	{
	    if (!instance->onExit) return;
	    xnUnregisterFromUserExit (instance->handle, instance->onExit);
	    Tcl_DecrRefCount (instance->cmdExit);

	    instance->onExit = NULL;
	    instance->cmdExit = NULL;
	}

	static int
	kinetcl_user_exit_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	{
	    Tcl_Obj* cmd;
	    XnCallbackHandle h;
	    XnStatus s;

	    s = xnRegisterToUserExit (instance->handle,
				      kinetcl_user_exit_handle,
				      instance, &h);
	    if (s != XN_STATUS_OK) {
		Tcl_AppendResult (instance->interp, xnGetStatusString (s), NULL);
		return TCL_ERROR;
	    }

	    kinetcl_user_exit_unset (instance);

	    instance->onExit  = h;
	    instance->cmdExit = Tcl_NewListObj (objc, objv);
	    return TCL_OK;
	}

	/* ======================================================================= */
	static void
	kinetcl_user_enter_handle (XnNodeHandle h, XnUserID u, void* clientData)
	{
	    int res;
	    Tcl_Obj* cmd;
	    Tcl_Obj* self;
	    @instancetype@ instance = (@instancetype@) clientData;
	    /* ASSERT (h == instance->handle) ? */

	    self = Tcl_NewObj ();
	    Tcl_GetCommandFullName (instance->interp, instance->cmd, self);

	    cmd = Tcl_DuplicateObj (instance->cmdEnter);
	    Tcl_ListObjAppendElement (instance->interp, cmd, self);
	    Tcl_ListObjAppendElement (instance->interp, cmd, Tcl_NewIntObj (u));

	    /* Invoke "{*}$cmdprefix $self $userid" */
	    res = Tcl_GlobalEvalObj (instance->interp, cmd);

	    Tcl_DecrRefCount (cmd);
	}

	static void
	kinetcl_user_enter_unset (@instancetype@ instance)
	{
	    if (!instance->onEnter) return;
	    xnUnregisterFromUserReEnter (instance->handle, instance->onEnter);
	    Tcl_DecrRefCount (instance->cmdEnter);

	    instance->onEnter = NULL;
	    instance->cmdEnter = NULL;
	}

	static int
	kinetcl_user_enter_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	{
	    Tcl_Obj* cmd;
	    XnCallbackHandle h;
	    XnStatus s;

	    s = xnRegisterToUserReEnter (instance->handle,
					 kinetcl_user_enter_handle,
					 instance, &h);
	    if (s != XN_STATUS_OK) {
		Tcl_AppendResult (instance->interp, xnGetStatusString (s), NULL);
		return TCL_ERROR;
	    }

	    kinetcl_user_enter_unset (instance);

	    instance->onEnter  = h;
	    instance->cmdEnter = Tcl_NewListObj (objc, objv);
	    return TCL_OK;
	}

	/* ======================================================================= */
	static void
	kinetcl_user_newlost_handle_new (XnNodeHandle h, XnUserID u, void* clientData)
	{
	    XnStatus s;
	    int res;
	    Tcl_Obj* cmd;
	    Tcl_Obj* self;
	    @instancetype@ instance = (@instancetype@) clientData;
	    /* ASSERT (h == instance->handle) ? */

	    self = Tcl_NewObj ();
	    Tcl_GetCommandFullName (instance->interp, instance->cmd, self);

	    cmd = Tcl_DuplicateObj (instance->cmdNewLost);
	    Tcl_ListObjAppendElement (instance->interp, cmd, self);
	    Tcl_ListObjAppendElement (instance->interp, cmd,
				      kinetcl_context (instance->interp, &s)->strNew);
	    Tcl_ListObjAppendElement (instance->interp, cmd, Tcl_NewIntObj (u));

	    /* Invoke "{*}$cmdprefix new $self $userid" */
	    res = Tcl_GlobalEvalObj (instance->interp, cmd);

	    Tcl_DecrRefCount (cmd);
	}

	static void
	kinetcl_user_newlost_handle_lost (XnNodeHandle h, XnUserID u, void* clientData)
	{
	    XnStatus s;
	    int res;
	    Tcl_Obj* cmd;
	    Tcl_Obj* self;
	    @instancetype@ instance = (@instancetype@) clientData;
	    /* ASSERT (h == instance->handle) ? */

	    self = Tcl_NewObj ();
	    Tcl_GetCommandFullName (instance->interp, instance->cmd, self);

	    cmd = Tcl_DuplicateObj (instance->cmdNewLost);
	    Tcl_ListObjAppendElement (instance->interp, cmd, self);
	    Tcl_ListObjAppendElement (instance->interp, cmd,
				      kinetcl_context (instance->interp, &s)->strLost);
	    Tcl_ListObjAppendElement (instance->interp, cmd, Tcl_NewIntObj (u));

	    /* Invoke "{*}$cmdprefix lost $self $userid" */
	    res = Tcl_GlobalEvalObj (instance->interp, cmd);

	    Tcl_DecrRefCount (cmd);
	}

	static void
	kinetcl_user_newlost_unset (@instancetype@ instance)
	{
	    if (!instance->onNewLost) return;
	    xnUnregisterUserCallbacks (instance->handle, instance->onNewLost);
	    Tcl_DecrRefCount (instance->cmdNewLost);

	    instance->onNewLost = NULL;
	    instance->cmdNewLost = NULL;
	}

	static int
	kinetcl_user_newlost_set (@instancetype@ instance, int objc, Tcl_Obj*const* objv)
	{
	    Tcl_Obj* cmd;
	    XnCallbackHandle h;
	    XnStatus s;

	    s = xnRegisterUserCallbacks (instance->handle,
					 kinetcl_user_newlost_handle_new,
					 kinetcl_user_newlost_handle_lost,
					 instance, &h);
	    if (s != XN_STATUS_OK) {
		Tcl_AppendResult (instance->interp, xnGetStatusString (s), NULL);
		return TCL_ERROR;
	    }

	    kinetcl_user_newlost_unset (instance);

	    instance->onNewLost  = h;
	    instance->cmdNewLost = Tcl_NewListObj (objc, objv);
	    return TCL_OK;
	}
    }
    # # ## ### ##### ######## #############
}

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

# # ## ### ##### ######## #############
## Audio Generator

critcl::class def kinetcl::audio {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI audio generator object}

    constructor {
	kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The audio generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain audio generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateAudioGenerator (c->context, &h, NULL, NULL);
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

# # ## ### ##### ######## #############
## Recorder

critcl::class def kinetcl::recorder {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI recorder object}

    constructor {
	kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The recorder's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain recorder object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateRecorder (c->context, NULL, &h);
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

# # ## ### ##### ######## #############
## Script

critcl::class def kinetcl::script {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI script object}

    constructor {
	kinetcl_ctx* c; /* The package's OpenNI context, per-interp global */
	XnStatus     s; /* Status of various OpenNI operations */
	XnNodeHandle h; /* The script's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain script object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateScriptNode (c->context, "oni", &h); // XXX TODO: Which script formats exist ?
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

# # ## ### ##### ######## #############
## Make the C pieces ready. Immediate build of the binaries, no deferal.

if {![critcl::load]} {
    error "Building and loading KineTcl failed."
}

# # ## ### ##### ######## #############

package provide kinetcl 0
return

# vim: set sts=4 sw=4 tw=80 et ft=tcl:
