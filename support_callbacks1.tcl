## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we define how single callbacks are handled.

# # ## ### ##### ######## #############

proc kt_callback {name consfunction destfunction signature body {mode all} {detail {}}} {
    # The additional offset (3 == \n\n\n) gets added because of the
    # way we are formatting the calls of this procedure, with
    # continuation lines between the first four arguments.
    critcl::at::caller
    critcl::at::incrt \n\n\n $signature
    set bloc [critcl::at::get*]

    set cname [kt_cb_cname $name]

    # Define the raw callback processing.
    kt_cb_handler $name $name $cname $signature $bloc$body $mode

    lappend map @@cname@@         $cname 
    insvariable XnCallbackHandle callback$cname "
	Handle for $name callbacks
    " [string map $map {
	instance->callback@@cname@@ = NULL;
    }] [string map $map {
	@stem@_callback_@@cname@@_unset (instance, 1);
    }]

    kt_cb_methods \
	$cname $name $cname [list $cname] \
	$consfunction $destfunction \
	$detail
    return
}

# # ## ### ##### ######## #############
return
