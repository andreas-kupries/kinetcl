# # ## ### ##### ######## #############
## Capability Class

critcl::class def ::kinetcl::CapAntiflickerC {
    # # ## ### ##### ######## #############
    ::kt_abstract_class

    # # ## ### ##### ######## #############

    method @frequency: proc {XnPowerLineFrequency f} XnStatus {
	return xnSetPowerLineFrequency (instance->handle, f);
    }

    method @frequency? proc {} XnPowerLineFrequency {
	return xnGetPowerLineFrequency (instance->handle);
    }

    # # ## ### ##### ######## #############

    kt_callback frequency \
	xnRegisterToPowerLineFrequencyChange \
	xnUnregisterFromPowerLineFrequencyChange \
    {} {}

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
