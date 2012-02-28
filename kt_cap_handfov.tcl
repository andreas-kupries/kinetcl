# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapHandTouchingFovEdge {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    support {
	static const char* @stem@_direction [] = {
	    "illegal",	/* XN_DIRECTION_ILLEGAL	 */
	    "left",	/* XN_DIRECTION_LEFT 	 */
	    "right",	/* XN_DIRECTION_RIGHT 	 */
	    "up",	/* XN_DIRECTION_UP 	 */
	    "down",	/* XN_DIRECTION_DOWN 	 */
	    "forward",	/* XN_DIRECTION_FORWARD	 */
	    "backward",	/* XN_DIRECTION_BACKWARD */
	    NULL
	};
    }

    # # ## ### ##### ######## #############

    ::kt_callback fovEdge \
	xnRegisterToHandTouchingFOVEdge \
	xnUnregisterFromHandTouchingFOVEdge \
	{
	    {XnUserID         user}
	    {const XnPoint3D* pPosition}
	    {XnFloat          fTime}
	    {XnDirection      eDir}
	} {
	    Tcl_Obj* coord [3];

	    coord [0] = Tcl_NewDoubleObj (pPosition->X);
	    coord [1] = Tcl_NewDoubleObj (pPosition->Y);
	    coord [2] = Tcl_NewDoubleObj (pPosition->Z);

	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewIntObj (user));
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewListObj (3, coord));
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewDoubleObj (fTime));
	    Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj (@stem@_direction [eDir],-1));
	}

    # # ## ### ##### ######## #############

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
