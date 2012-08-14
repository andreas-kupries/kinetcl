## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we provide setup of the capabilities based on the general int
## capability of nodes.

# # ## ### ##### ######## #############

proc kt_cap_integer {capname nicapname} {
    lappend map @@capname@@     $capname 
    lappend map @@nicapname@@   $nicapname
    lappend map @@capcallback@@ $capname

    # # ## ### ##### ######## #############
    kt_abstract_class

    method $capname command {
	objv[2] = value, optional
    } [string map $map {
	return kinetcl_cap_integer_rw (instance->handle, "@@nicapname@@", interp, objc, objv);
    }]

    method ${capname}-range proc {} ok [string map $map {
	return kinetcl_cap_integer_range (instance->handle, "@@nicapname@@", interp);
    }]

    kt_callback $capname \
	xnRegisterToGeneralIntValueChange \
	xnUnregisterFromGeneralIntValueChange \
	{} {} all $nicapname

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
return
