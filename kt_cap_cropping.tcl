# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapCroppingC {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method @crop: proc {int x int y int w int h} XnStatus {
	XnCropping c;
	c.nXOffset = x;
	c.nYOffset = y;
	c.nXSize = w;
	c.nYSize = h;
	c.bEnabled = 1;

	return xnSetCropping (instance->handle, &c);
    }

    method @crop? proc {} ok {
	XnStatus s;
	XnCropping c;
	Tcl_Obj* cv[5];

	s = xnGetCropping (instance->handle, &c);
	CHECK_STATUS_RETURN;

	cv [0] = Tcl_NewIntObj (c.bEnabled);
	cv [1] = Tcl_NewIntObj (c.nXOffset);
	cv [2] = Tcl_NewIntObj (c.nYOffset);
	cv [3] = Tcl_NewIntObj (c.nXSize);
	cv [4] = Tcl_NewIntObj (c.nYSize);

	Tcl_SetObjResult (interp, Tcl_NewListObj (5, cv));
	return TCL_OK;
    }

    method uncrop proc {} XnStatus {
	XnCropping c;

	c.bEnabled = 0;
	c.nXOffset = 0;
	c.nYOffset = 0;
	c.nXSize = 0;
	c.nYSize = 0;

	return xnSetCropping (instance->handle, &c);
    }

    # # ## ### ##### ######## #############

    kt_callback cropping \
	xnRegisterToCroppingChange \
	xnUnregisterFromCroppingChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
