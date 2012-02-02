
# # ## ### ##### ######## #############
## Gesture Generator

critcl::class def kinetcl::Gesture {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain gesture generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateGestureGenerator (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############
    # # ## ### ##### ######## #############

    ::kt_2callback gesture \
	xnRegisterGestureCallbacks \
	xnUnregisterGestureCallbacks \
	gestureRecognized {
	    {const XnChar*    strGesture}
	    {const XnPoint3D* pIDPosition}
	    {const XnPoint3D* pEndPosition}
	} {
	    Tcl_Obj* coord [3];

	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (strGesture,-1));

	    coord [0] = Tcl_NewDoubleObj (pIDPosition->X);
	    coord [1] = Tcl_NewDoubleObj (pIDPosition->Y);
	    coord [2] = Tcl_NewDoubleObj (pIDPosition->Z);
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3,coord));

	    coord [0] = Tcl_NewDoubleObj (pEndPosition->X);
	    coord [1] = Tcl_NewDoubleObj (pEndPosition->Y);
	    coord [2] = Tcl_NewDoubleObj (pEndPosition->Z);
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3,coord));
	} \
	gestureProgress {
	    {const XnChar*    strGesture}
	    {const XnPoint3D* pPosition}
	    {XnFloat          fProgress}
	} {
	    Tcl_Obj* coord [3];

	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (strGesture,-1));

	    coord [0] = Tcl_NewDoubleObj (pPosition->X);
	    coord [1] = Tcl_NewDoubleObj (pPosition->Y);
	    coord [2] = Tcl_NewDoubleObj (pPosition->Z);
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3,coord));

	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewDoubleObj (fProgress));
	}

    ::kt_callback gestureChange \
	xnRegisterToGestureChange \
	xnUnregisterFromGestureChange \
	{} {}

    ::kt_callback gestureStageComplete \
	xnRegisterToGestureIntermediateStageCompleted \
	xnUnregisterFromGestureIntermediateStageCompleted \
	{
	    {const XnChar*    strGesture}
	    {const XnPoint3D* pPosition}
	} {
	    Tcl_Obj* coord [3];

	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (strGesture,-1));

	    coord [0] = Tcl_NewDoubleObj (pPosition->X);
	    coord [1] = Tcl_NewDoubleObj (pPosition->Y);
	    coord [2] = Tcl_NewDoubleObj (pPosition->Z);
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3,coord));
	}

    ::kt_callback gestureStageReadyForNext \
	xnRegisterToGestureReadyForNextIntermediateStage \
	xnUnregisterFromGestureReadyForNextIntermediateStage \
	{
	    {const XnChar*    strGesture}
	    {const XnPoint3D* pPosition}
	} {
	    Tcl_Obj* coord [3];

	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (strGesture,-1));

	    coord [0] = Tcl_NewDoubleObj (pPosition->X);
	    coord [1] = Tcl_NewDoubleObj (pPosition->Y);
	    coord [2] = Tcl_NewDoubleObj (pPosition->Z);
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3,coord));
	}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
