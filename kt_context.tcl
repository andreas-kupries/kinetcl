## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines the per-intepreter structures collecting
## information relevant to the whole package, i.e. all classes and
## instances. All classes, and instances will have a reference to this
## structure which is initialized at class and instance construction
## time, via kinetcl_context ().

# # ## ### ##### ######## #############

critcl::buildrequirement {
    package require critcl::iassoc
}

# # ## ### ##### ######## #############

critcl::ccode {
    #include <XnOpenNI.h>

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

#define CHECK_STATUS_RETURN_NULL \
	if (s != XN_STATUS_OK) { \
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL); \
	    return NULL; \
	}

#define CB_DETAIL(s,o) Tcl_DictObjPut (interp, details, Tcl_NewStringObj (s, sizeof(s)), o)

	/* Common event fields for kinetcl callback events. Tcl's
	 * information, plus a pointer to a package- and event-specific
	 * cleanup function. It enables cleanup without knowing anything
	 * about the internals of the event to be deleted.
	 */

	typedef struct Kinetcl_Event Kinetcl_Event;
	typedef void (*Kinetcl_EventDeleteProc) (Kinetcl_Event* evPtr);

	struct Kinetcl_Event {
	    Tcl_Event               event;
	    Kinetcl_EventDeleteProc delproc;
	};
}

# # ## ### ##### ######## #############

critcl::iassoc::def kinetcl_context {} {
    /* Our OpenNI context
     */
    XnContext* context;

    /* The stash/cache used by instances to propagate their handle to
     * base classes without having to expose the handle/pointer to the
     * Tcl level.
     */
    XnNodeHandle mark;

    /* Global event lock, protection, and queue of defered events.
     */

    int            eventLock;
    Tcl_Mutex      eventLockMutex;
    Kinetcl_Event* eventDefered;
    Tcl_ThreadId   eventOwner;
} {
    XnStatus s = xnInit (&data->context);

    if (s != XN_STATUS_OK) {
	Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	goto error;
    }

    data->mark = 0;
    data->eventLock = 0;
    data->eventLockMutex = 0;
    data->eventDefered = 0;
    data->eventOwner = Tcl_GetCurrentThread();
} {
    xnContextRelease (data->context);
    Tcl_MutexFinalize (&data->eventLockMutex);
    /* Clean up all unprocessed defered events */
    while (data->eventDefered) {
	Tcl_Event* next = data->eventDefered->event.nextPtr;
	data->eventDefered->delproc (data->eventDefered);
	ckfree ((char*) data->eventDefered);
	data->eventDefered = (Kinetcl_Event*) next;
    }
}

# # ## ### ##### ######## #############
## Validation at C-level. Calls out to Tcl, where this was much easier
## to implement.  Automatically cleans up the stash through which the
## handle is communicated to us. Nothing the caller has to bother
## with.

critcl::ccode {
    static int
    kinetcl_validate (Tcl_Interp* interp, Tcl_Obj* o, XnNodeHandle* handle)
    {
	kinetcl_context_data c;
	Tcl_Obj* cv [2];

	cv [0] = Tcl_NewStringObj ("::kinetcl::Valid",-1);
	cv [1] = o;

	if (Tcl_EvalObjv (interp, 2, cv, 0) != TCL_OK) {
	    return TCL_ERROR;
	}

	c = kinetcl_context (interp);

	*handle = c->mark;
	c->mark = NULL;
	return TCL_OK;
    }

    static void
    kinetcl_lock (Tcl_Interp* interp)
    {
	kinetcl_context_data c = kinetcl_context (interp);
	Tcl_MutexLock (&c->eventLockMutex);
	c->eventLock = 1;
	Tcl_MutexUnlock (&c->eventLockMutex);
    }

    static void
    kinetcl_unlock (Tcl_Interp* interp)
    {
	kinetcl_context_data c = kinetcl_context (interp);
	Tcl_MutexLock (&c->eventLockMutex);
	c->eventLock = 0;

	/* Move all unprocessed defered events into the queue proper */
	while (c->eventDefered) {
	    Tcl_Event* next = c->eventDefered->event.nextPtr;
	    Tcl_ThreadQueueEvent(c->eventOwner,
				 (Tcl_Event *) c->eventDefered,
				 TCL_QUEUE_HEAD);
	    /* Note: The events are added at the HEAD because the
	     * deferal queue is actually a stack, and its inversion of
	     * event order during lockout is inverted by this here again,
	     * restoring proper order.
	     */
	    c->eventDefered = (Kinetcl_Event*) next;
	}
	Tcl_MutexUnlock (&c->eventLockMutex);
	Tcl_ThreadAlert (c->eventOwner);
    }

    static int
    kinetcl_locked (kinetcl_context_data c, Kinetcl_Event* evPtr)
    {
	int locked;
	Tcl_MutexLock (&c->eventLockMutex);
	locked = c->eventLock;
	if (locked) {
	    /* Defer the event */
	    evPtr->event.nextPtr = (Tcl_Event*) c->eventDefered;
	    c->eventDefered = evPtr;
	}
	Tcl_MutexUnlock (&c->eventLockMutex);
	return locked;
    }

    static int
    kinetcl_cap_integer_rw (XnNodeHandle handle, char* cap,
			    Tcl_Interp* interp, int objc, Tcl_Obj* const* objv)
    {
	if (objc == 2) { /* Syntax: <instance> .capname. */
	    XnStatus s;
	    XnInt32 value;

	    s = xnGetGeneralIntValue (handle, cap, &value);
	    CHECK_STATUS_RETURN;

	    Tcl_SetObjResult (interp, Tcl_NewIntObj (value));
	    return TCL_OK;
	}

	if (objc == 3) { /* Syntax: <instance> .capname. */
	    XnStatus s;
	    int value;

	    if (Tcl_GetIntFromObj (interp, objv [2], &value) != TCL_OK) {
		return TCL_ERROR;
	    }

	    s = xnSetGeneralIntValue (handle, cap, value);
	    CHECK_STATUS_RETURN;

	    return TCL_OK;
	}

	Tcl_WrongNumArgs (interp, 2, objv, "?n?");
	return TCL_ERROR;
    }

    static int
    kinetcl_cap_integer_range (XnNodeHandle handle, char* cap,
			       Tcl_Interp* interp)
    {
	XnStatus s;
	XnInt32 vmin, vmax, vstep, vdefault;
	XnBool hasAuto;
	Tcl_Obj* res;

	s = xnGetGeneralIntRange (handle, cap, &vmin, &vmax, &vstep, &vdefault, &hasAuto);
	CHECK_STATUS_RETURN;

	res = Tcl_NewDictObj ();
	Tcl_DictObjPut (NULL, res, Tcl_NewStringObj ("min",-1),     Tcl_NewIntObj (vmin));
	Tcl_DictObjPut (NULL, res, Tcl_NewStringObj ("max",-1),     Tcl_NewIntObj (vmax));
	Tcl_DictObjPut (NULL, res, Tcl_NewStringObj ("step",-1),    Tcl_NewIntObj (vstep));
	Tcl_DictObjPut (NULL, res, Tcl_NewStringObj ("default",-1), Tcl_NewIntObj (vdefault));
	Tcl_DictObjPut (NULL, res, Tcl_NewStringObj ("auto",-1),    Tcl_NewIntObj (hasAuto));

	Tcl_SetObjResult (interp, res);
	return TCL_OK;
    }
}

# # ## ### ##### ######## #############
## Custom argument type for cprocs and cproc-like methods.
## Conversion of Tcl_Obj* to XnNodeHandle.

critcl::argtype XnNodeHandle {
    if (kinetcl_validate(ip, @@, &@A) != TCL_OK) return TCL_ERROR;
}

critcl::resulttype XnStatus {
    if (rv != XN_STATUS_OK) {
	Tcl_AppendResult (ip, xnGetStatusString (rv), NULL);
	return TCL_ERROR;
    }
    return TCL_OK;
}

# # ## ### ##### ######## #############

critcl::cproc ::kinetcl::estart {Tcl_Interp* interp} ok {
    kinetcl_unlock (interp);
    return TCL_OK;
}

critcl::cproc ::kinetcl::estop {Tcl_Interp* interp} ok {
    kinetcl_lock (interp);
    return TCL_OK;
}

# # ## ### ##### ######## #############

critcl::cproc ::kinetcl::start {Tcl_Interp* interp} ok {
    XnStatus s = xnStartGeneratingAll (kinetcl_context (interp)->context);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

critcl::cproc ::kinetcl::stop {Tcl_Interp* interp} ok {
    XnStatus s = xnStopGeneratingAll (kinetcl_context (interp)->context);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

# # ## ### ##### ######## #############

critcl::cproc ::kinetcl::waitUpdate {Tcl_Interp* interp} ok {
    XnStatus s = xnWaitAndUpdateAll (kinetcl_context (interp)->context);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

critcl::cproc ::kinetcl::waitAnyUpdate {Tcl_Interp* interp} ok {
    XnStatus s = xnWaitAnyUpdateAll (kinetcl_context (interp)->context);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

critcl::cproc ::kinetcl::waitNoneUpdate {Tcl_Interp* interp} ok {
    XnStatus s = xnWaitNoneUpdateAll (kinetcl_context (interp)->context);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

critcl::cproc ::kinetcl::waitOneUpdate {Tcl_Interp* interp Tcl_Obj* o} ok {
    XnStatus s;
    kinetcl_context_data c = kinetcl_context (interp);
    XnNodeHandle handle;

    if (kinetcl_validate (interp, o, &handle) != TCL_OK) {
	return TCL_ERROR;
    }

    s = xnWaitOneUpdateAll (c->context, handle);
    CHECK_STATUS_RETURN;
    return TCL_OK;
}

# # ## ### ##### ######## #############

critcl::cproc ::kinetcl::errorstate {Tcl_Interp* interp} ok {
    XnStatus s = xnGetGlobalErrorState (kinetcl_context (interp)->context);
    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
    return TCL_OK;
}

# # ## ### ##### ######## #############

critcl::ccommand ::kinetcl::mirror {} {  /* Syntax: mirror ?bool? */
    kinetcl_context_data c = kinetcl_context (interp);

    if (objc == 1) { /* Syntax: mirror */
	XnBool m = xnGetGlobalMirror (c->context);

	Tcl_SetObjResult (interp, Tcl_NewIntObj (m));
	return TCL_OK;
    }

    if (objc == 2) { /* Syntax: mirror bool */
	XnStatus s;
	int      m;

	if (Tcl_GetBooleanFromObj (interp, objv [1], &m) != TCL_OK) {
	    return TCL_ERROR;
	}

	s = xnSetGlobalMirror (c->context, m);
	CHECK_STATUS_RETURN;

	return TCL_OK;
    }

    Tcl_WrongNumArgs (interp, 1, objv, "?bool?");
    return TCL_ERROR;
}

# # ## ### ##### ######## #############
## Need a way for the kt_callback to operate without a class around it.
if 0 {
XnStatus xnRegisterToGlobalErrorStateChange     (XnContext *pContext, XnErrorStateChangedHandler handler, void *pCookie, XnCallbackHandle *phCallback)
void 	 xnUnregisterFromGlobalErrorStateChange (XnContext *pContext, XnCallbackHandle hCallback)
}
# # ## ### ##### ######## #############
return
