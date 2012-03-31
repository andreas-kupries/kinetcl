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

    ::kt_callback fov-edge \
	xnRegisterToHandTouchingFOVEdge \
	xnUnregisterFromHandTouchingFOVEdge \
	{
	    {XnUserID         hand}
	    {const XnPoint3D* pPosition}
	    {XnFloat          fTime}
	    {XnDirection      eDir}
	} {
	    CB_DETAIL ("hand",      Tcl_NewIntObj (hand));			 
	    CB_DETAIL ("position",  kinetcl_convert_3d (pPosition));		
	    CB_DETAIL ("time",      Tcl_NewDoubleObj (fTime));	      
	    CB_DETAIL ("direction", Tcl_NewStringObj (@stem@_direction [eDir],-1));
	}

    # # ## ### ##### ######## #############

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
