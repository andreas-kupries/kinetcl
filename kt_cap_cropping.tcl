# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapCropping {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # XXX TODO Implement the API.

    # # ## ### ##### ######## #############

    # # ## ### ##### ######## #############

    # # ## ### ##### ######## #############

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
if 0 {
    XnCropping {
	XnBool 	bEnabled
	XnUInt16 	nXOffset
	XnUInt16 	nYOffset
	XnUInt16 	nXSize
	XnUInt16 	nYSize
    }

XnStatus xnSetCropping (XnNodeHandle hInstance, const XnCropping *pCropping)
XnStatus xnGetCropping (XnNodeHandle hInstance,       XnCropping *pCropping)

XnStatus xnRegisterToCroppingChange (XnNodeHandle hInstance, XnStateChangedHandler handler, void *pCookie, XnCallbackHandle *phCallback)
void 	xnUnregisterFromCroppingChange (XnNodeHandle hInstance, XnCallbackHandle hCallback)
}
