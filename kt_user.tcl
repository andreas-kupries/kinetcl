
# # ## ### ##### ######## #############
## User Generator

critcl::class def kinetcl::User {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain user generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	/* Fill our structure */
	instance->interp = interp;

	/* No callbacks at the beginning */
	instance->onExit    = NULL;
	instance->onEnter   = NULL;
	instance->onNewLost = NULL;

	instance->cmdExit    = NULL;
	instance->cmdEnter   = NULL;
	instance->cmdNewLost = NULL;

	s = xnCreateUserGenerator (instance->onicontext, &h, NULL, NULL);
    } {
	/* instance->interp is non-owned copy, nothing to do */
	kinetcl_user_exit_unset    (instance);
	kinetcl_user_enter_unset   (instance);
	kinetcl_user_newlost_unset (instance);
    }

    # # ## ### ##### ######## #############
    field Tcl_Interp*      interp     {Interpreter for the callbacks}

    field XnCallbackHandle onExit     {Handle for exit callbacks, if any}
    field XnCallbackHandle onEnter    {Handle for enter callbacks, if any}
    field XnCallbackHandle onNewLost  {Handle for New/Lost callbacks, if any}

    field Tcl_Obj* cmdExit    {And associated command prefixes}
    field Tcl_Obj* cmdEnter
    field Tcl_Obj* cmdNewLost

    # # ## ### ##### ######## #############
    mdef count {
	/* Syntax: count */
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
				      instance->context->strNew);
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
				      instance->context->strLost);
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
