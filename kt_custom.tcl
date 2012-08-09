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
	Tcl_AppendResult (interp, xnGetStatusString (rv), NULL);
	return TCL_ERROR;
    }
    return TCL_OK;
}

# # ## ### ##### ######## #############
## depth pixel value, with special casing for bad handles.

critcl::resulttype XnDepthPixel {
    if (rv == ((XnDepthPixel) -1)) {
	Tcl_AppendResult (interp, "Inheritance error: Not a depth generator", NULL);
	return TCL_ERROR;
    }
    Tcl_SetObjResult (interp, Tcl_NewIntObj (rv));
    return TCL_OK;
}

# # ## ### ##### ######## #############
## frame id, with special casing for bad handles.

critcl::resulttype KFrame {
    if (rv == ((XnUInt32) -1)) {
	Tcl_AppendResult (interp, "Inheritance error: Not a generator", NULL);
	return TCL_ERROR;
    }

    Tcl_SetObjResult (interp, Tcl_NewIntObj (rv));
    return TCL_OK;
} XnUInt32

# # ## ### ##### ######## #############
## timestamp, with special casing for bad handles.

critcl::resulttype KTimestamp {
    if (rv == ((XnUInt64) -1)) {
	Tcl_AppendResult (interp, "Inheritance error: Not a generator", NULL);
	return TCL_ERROR;
    }

    Tcl_SetObjResult (interp, Tcl_NewWideIntObj (rv));
    return TCL_OK;
} XnUInt64


# # ## ### ##### ######## #############
## pixel format, with special casing for bad handles.
## The string array kinetcl_pixelformat is defined in
## kt_image.tcl

critcl::resulttype XnPixelFormat {
    if (rv == (XnPixelFormat) -1) {
	Tcl_AppendResult (interp, "Inheritance error: Not an image generator", NULL);
	return TCL_ERROR;
    }
    /* ATTENTION: The array is 0-indexed, wheras the pixelformat 'rv' is 1-indexed */
    Tcl_SetObjResult (interp, Tcl_NewStringObj (kinetcl_pixelformat [rv-1],-1));
    return TCL_OK;
}

# kinetcl_pixelformat is defined in kt_image.tcl
critcl::argtype XnPixelFormat {
    if (Tcl_GetIndexFromObj (interp, @@, 
			     kinetcl_pixelformat,
			     "pixelformat", 0, &@A) != TCL_OK) {
	return TCL_ERROR;
    }
    @A ++; /* Convert from Tcl's 0-indexed value to OpenNI's 1-indexing. */
} int int

# # ## ### ##### ######## #############
## power line frequency, mainly numeric, with third bool value, and bad handles.

critcl::resulttype XnPowerLineFrequency {
    if (rv == ((XnPowerLineFrequency) -1)) {
	Tcl_AppendResult (interp, "Antiflicker not supported", NULL);
	return TCL_ERROR;
    }
    if (!rv) {
	Tcl_SetObjResult (interp, Tcl_NewStringObj ("off",-1));
    } else {
	Tcl_SetObjResult (interp, Tcl_NewIntObj (rv));
    }
    return TCL_OK;
}

critcl::argtype XnPowerLineFrequency {
    if (0 == strcmp ("off", Tcl_GetString (@@))) {
	@A = 0;
    } else if (Tcl_GetIntFromObj (interp, @@, &@A) != TCL_OK) {
	return TCL_ERROR;
    }
    if (@A && (@A != 50) && (@A != 60)) {
	char buf [20];
	sprintf (buf, "%d", @A);
	Tcl_AppendResult (interp, "Bad frequency ", buf, ", expected 50, 60, or off", NULL);
	return TCL_ERROR;
    }
} int XnPowerLineFrequency

# # ## ### ##### ######## #############
## Convert between between object commands (handles) in Tcl_Obj* and
## OpenNI XnNodeHandle's.

critcl::argtype XnNodeHandle {
    if (kinetcl_validate(interp, @@, &@A) != TCL_OK) return TCL_ERROR;
}

# # ## ### ##### ######## #############
## Convert Tcl_Obj* (3-element list, double elements) to a 3D point.

critcl::argtype XnPoint3D {
    if (kinetcl_convert_to3d (interp, @@, &@A) != TCL_OK) {
	return TCL_ERROR;
    }
}

# # ## ### ##### ######## #############
## Convert Tcl_Obj* (2-element list, 3D point elements) to a 3D bounding box.

critcl::argtype XnBoundingBox3D {
    if (kinetcl_convert_2bbox (interp, @@, &@A) != TCL_OK) {
	return TCL_ERROR;
    }
}

# # ## ### ##### ######## #############

# TODO: Move the various arrays of strings out of class definitions
# into the global package namespace ?! Maybe define special objtypes
# also ?!

# # ## ### ##### ######## #############
## Joint profile names to OpenNI numeric ids.
## String array defined in kt_cap_skeleton.tcl

critcl::argtype KJointProfile {
    if (Tcl_GetIndexFromObj (interp, @@, @stem@_skeleton_profile,
			     "profile", 0, &@A) != TCL_OK) {
	return TCL_ERROR;
    }
    @A ++; /* Convert from Tcl's 0-indexed value to OpenNI's 1-indexing. */
} int int

# # ## ### ##### ######## #############
## Joint names to OpenNI numeric ids.
## String array defined in kt_cap_skeleton.tcl

critcl::argtype KJoint {
    if (Tcl_GetIndexFromObj (interp, @@, @stem@_skeleton_joint,
			     "joint", 0, &@A) != TCL_OK) {
	return TCL_ERROR;
    }
    @A ++; /* Convert from Tcl's 0-indexed value to OpenNI's 1-indexing. */
} int int


# # ## ### ##### ######## #############
## Capability names, Tcl to OpenNI.
## The arrays 
##     @stem@_tcl_capability_names
## and @stem@_oni_capability_names
## are currently defined in "kt_base.tcl".
## Move to separate file and more global ?

critcl::argtype KCapability {
    /* List of cap names - XnTypes.h, as defines XN_CAPABILITY_xxx */
    int id;
    if (Tcl_GetIndexFromObj (interp, @@, 
			     @stem@_tcl_capability_names,
			     "capability", 0, &id) != TCL_OK) {
	return TCL_ERROR;
    }

    /* Translate Tcl to C/OpenNI */
    @A = (char*) @stem@_oni_capability_names [id];
} char* {const char*}


# # ## ### ##### ######## #############
return
