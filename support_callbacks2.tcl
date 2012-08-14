## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we define how double callbacks are handled and exposed to
## users. That are callbacks where OpenNI manages two related
## callbacks through a single (un)registration API.

# # ## ### ##### ######## #############

proc kt_2callback {name consfunction destfunction namea signaturea bodya nameb signatureb bodyb} {
    # The additional offsets (3 and 1 == \n\n\n, \n) are added because
    # of the way we are formatting the calls of this procedure with
    # continuation lines between the first four arguments and after
    # the first body.
    critcl::at::caller
    critcl::at::incrt \n\n\n        $signaturea  ; set aloc [critcl::at::get*]
    critcl::at::incrt \n     $bodya $signatureb  ; set bloc [critcl::at::get]

    set cname  [kt_cb_cname $name]
    set cnamea [kt_cb_cname $namea]
    set cnameb [kt_cb_cname $nameb]

    # Define the raw callback processing.
    kt_cb_handler $name $namea $cnamea $signaturea $aloc$bodya
    kt_cb_handler $name $nameb $cnameb $signatureb $bloc$bodyb

    lappend map @@cname@@         $cname
    lappend map @@cnamea@@        $cnamea
    lappend map @@cnameb@@        $cnameb

    insvariable XnCallbackHandle callback$cname "
	Handle for $name callbacks
    " [string map $map {
	instance->callback@@cname@@ = NULL;
    }] [string map $map {
	@stem@_callback_@@cnamea@@_unset (instance, 1);
	@stem@_callback_@@cnameb@@_unset (instance, 1);
    }]

    set all [list $cnamea $cnameb]
    kt_cb_methods $cname $namea $cnamea $all $consfunction $destfunction
    kt_cb_methods $cname $nameb $cnameb $all $consfunction $destfunction
    return
}

# # ## ### ##### ######## #############
return
