# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapAntiflicker {
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
enum XnPowerLineFrequency

Enumerator:
    XN_POWER_LINE_FREQUENCY_OFF 	
    XN_POWER_LINE_FREQUENCY_50_HZ 	
    XN_POWER_LINE_FREQUENCY_60_HZ

XnStatus	     xnSetPowerLineFrequency (XnNodeHandle hGenerator, XnPowerLineFrequency nFrequency)
XnPowerLineFrequency xnGetPowerLineFrequency (XnNodeHandle hGenerator)

XnStatus xnRegisterToPowerLineFrequencyChange (XnNodeHandle hGenerator, XnStateChangedHandler handler, void *pCookie, XnCallbackHandle *phCallback)
void 	 xnUnregisterFromPowerLineFrequencyChange (XnNodeHandle hGenerator, XnCallbackHandle hCallback)

}
