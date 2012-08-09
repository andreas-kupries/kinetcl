# # ## ### ##### ######## #############
## Custom argument and result types for cproc and cproc-like methods.
## Declare conversion between the Tcl and C levels.
##
## Where we are (can) working with OpenNI types we use register the
## conversions under their names. For things without proper OpenNI type
## we use a K prefix.

# # ## ### ##### ######## #############
## The most important result type, IMHO.
## Many OpenNI functions just return an XnStatus.

critcl::resulttype XnStatus {
    if (rv != XN_STATUS_OK) {
	Tcl_AppendResult (ip, xnGetStatusString (rv), NULL);
	return TCL_ERROR;
    }
    return TCL_OK;
}

# # ## ### ##### ######## #############
## Convert between between object commands (handles) in Tcl_Obj* and
## OpenNI XnNodeHandle's.

critcl::argtype XnNodeHandle {
    if (kinetcl_validate(ip, @@, &@A) != TCL_OK) return TCL_ERROR;
}

# # ## ### ##### ######## #############
## Convert Tcl_Obj* (3-element list, double elements) to a 3D point.

critcl::argtype XnPoint3D {
    if (kinetcl_convert_to3d (ip, @@, &@A) != TCL_OK) {
	return TCL_ERROR;
    }
}

# # ## ### ##### ######## #############

# TODO: Move the various arrays of strings out of class definitions
# into the global package namespace ?! Maybe define special objtypes
# also ?!

# # ## ### ##### ######## #############
## Joint profile names to OpenNI numeric ids.

critcl::argtype KJointProfile {
    if (Tcl_GetIndexFromObj (ip, @@, @stem@_skeleton_profile,
			     "profile", 0, &@A) != TCL_OK) {
	return TCL_ERROR;
    }
    @A ++; /* Convert from Tcl's 0-indexed value to OpenNI's 1-indexing. */
} int int

# # ## ### ##### ######## #############
## Joint names to OpenNI numeric ids.

critcl::argtype KJoint {
    if (Tcl_GetIndexFromObj (ip, @@, @stem@_skeleton_joint,
			     "joint", 0, &@A) != TCL_OK) {
	return TCL_ERROR;
    }
    @A ++; /* Convert from Tcl's 0-indexed value to OpenNI's 1-indexing. */
} int int

# # ## ### ##### ######## #############
return
