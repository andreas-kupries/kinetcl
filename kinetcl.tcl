# -*- tcl -*-
# KineTcl = A Tcl Binding for MS Kinect, based on the OpenNI framework
#
# (c) 2012 Andreas Kupries http://wiki.tcl.tk/andreas%20kupries
#

# # ## ### ##### ######## #############
## Requisites

package require critcl 3.1
critcl::buildrequirement {
    package require critcl::util 1
    package require critcl::class 1
}

# # ## ### ##### ######## #############

if {![critcl::compiling]} {
    error "Unable to build KineTcl, no proper compiler found."
}

# # ## ### ##### ######## #############
## Administrivia

critcl::license \
    {Andreas Kupries} \
    {Under a BSD license.}

critcl::summary \
    {OpenNI based Tcl binding to Kinect and similar sensor systems}

critcl::description {
    This package provides access to Kinect and similar sensor system,
    through binding to the OpenNI framework.
}

critcl::subject kinect primesense oenni nite game

# # ## ### ##### ######## #############
## Implementation.

critcl::tcl 8.5

# # ## ### ##### ######## #############
## Declarations and linkage of the OpenNI framework we are binding to.

critcl::cheaders   -I/usr/include/ni ; # XXX TODO automatic search/configuration
critcl::clibraries -lOpenNI

# # ## ### ##### ######## #############
## Declare the Tcl layer aggregating the C primitives / classes into
## useful commands and hierarchies.

critcl::tsources eventbase.tcl        ; # Core event management and translation of
critcl::tsources nodeevents.tcl       ; # callbacks to multi-destination events.
critcl::tsources eventbindings.tcl    ; # Manager for bindings (remember, unbind)

critcl::tsources policy_base.tcl      ; #         /Abstract Class
critcl::tsources policy_player.tcl    ; # -> base
critcl::tsources policy_recorder.tcl  ; # -> base
critcl::tsources policy_script.tcl    ; # -> base

critcl::tsources policy_generator.tcl ; #              -> base /Abstract Class
critcl::tsources policy_audio.tcl     ; # -> generator -> base
critcl::tsources policy_gesture.tcl   ; # -> generator -> base
critcl::tsources policy_hands.tcl     ; # -> generator -> base
critcl::tsources policy_user.tcl      ; # -> generator -> base

critcl::tsources policy_map.tcl       ; #        -> generator -> base /Abstract Class
critcl::tsources policy_depth.tcl     ; # -> map -> generator -> base
critcl::tsources policy_image.tcl     ; # -> map -> generator -> base
critcl::tsources policy_ir.tcl        ; # -> map -> generator -> base
critcl::tsources policy_scene.tcl     ; # -> map -> generator -> base

critcl::tsources joints.tcl           ; # Highlevel skeleton/joint tracker with proper events.
critcl::tsources stance.tcl           ; # Highlevel stance/posture/body gesture detection.

critcl::tsources policy.tcl

# # ## ### ##### ######## #############
## Main C section.

critcl::api import crimp::core 0

# # ## ### ##### ######## #############
## C classes for the various types of objects.

critcl::source support.tcl ; # Build-time helper commands.

critcl::source kt_custom.tcl    ; # Custom argument and result types for cproc
critcl::source kt_context.tcl   ; # Per-interp package information,
#                                 # shared to all classes and instances.

critcl::source kt_base.tcl      ; #         /Abstract Class
critcl::source kt_player.tcl    ; # -> base
critcl::source kt_recorder.tcl  ; # -> base
critcl::source kt_script.tcl    ; # -> base

critcl::source kt_generator.tcl ; #              -> base /Abstract Class
critcl::source kt_audio.tcl     ; # -> generator -> base
critcl::source kt_gesture.tcl   ; # -> generator -> base
critcl::source kt_hands.tcl     ; # -> generator -> base
critcl::source kt_user.tcl      ; # -> generator -> base

critcl::source kt_map.tcl       ; #        -> generator -> base /Abstract Class
critcl::source kt_depth.tcl     ; # -> map -> generator -> base
critcl::source kt_image.tcl     ; # -> map -> generator -> base
critcl::source kt_ir.tcl        ; # -> map -> generator -> base
critcl::source kt_scene.tcl     ; # -> map -> generator -> base

# # ## ### ##### ######## #############

critcl::source kt_cap_skeleton.tcl      ; # capability 'user-skeleton'          <- user generator
critcl::source kt_cap_pose.tcl          ; # capability 'user-pose-detection'    <- user generator
critcl::source kt_cap_handfov.tcl       ; # capability 'hand-touching-fov-edge' <- user generator

critcl::source kt_cap_altview.tcl       ; # capability 'alternative-viewpoint'  <- generator
critcl::source kt_cap_framesync.tcl     ; # capability 'framesync'              <- generator
critcl::source kt_cap_mirror.tcl        ; # capability 'mirror                  <- generator

critcl::source kt_cap_antiflicker.tcl   ; # capability 'antiflicker'            <- map
critcl::source kt_cap_cropping.tcl      ; # capability 'cropping'               <- map

critcl::source kt_cap_userpos.tcl       ; # capability 'user-position'          <- depth

critcl::source kt_cap_eserial.tcl       ; # capability 'extended-serialization'
critcl::source kt_cap_lockaware.tcl     ; # capability 'lock-aware'

critcl::source kt_cap_backlightcomp.tcl ; # capability 'backlight-compensation'
critcl::source kt_cap_brightness.tcl    ; # capability 'brightness'
critcl::source kt_cap_colortemp.tcl     ; # capability 'color-temperature'
critcl::source kt_cap_contrast.tcl      ; # capability 'contrast'
critcl::source kt_cap_deviceid.tcl      ; # capability 'device-identification'
critcl::source kt_cap_errorstate.tcl    ; # capability 'error-state'
critcl::source kt_cap_exposure.tcl      ; # capability 'exposure'
critcl::source kt_cap_focus.tcl         ; # capability 'focus'
critcl::source kt_cap_gain.tcl          ; # capability 'gain'
critcl::source kt_cap_gamma.tcl         ; # capability 'gamma'
critcl::source kt_cap_hue.tcl           ; # capability 'hue'
critcl::source kt_cap_iris.tcl          ; # capability 'iris'
critcl::source kt_cap_lowlightcomp.tcl  ; # capability 'lowlight-compensation'
critcl::source kt_cap_pan.tcl           ; # capability 'pan'
critcl::source kt_cap_roll.tcl          ; # capability 'roll'
critcl::source kt_cap_saturation.tcl    ; # capability 'saturation'
critcl::source kt_cap_sharpness.tcl     ; # capability 'sharpness'
critcl::source kt_cap_tilt.tcl          ; # capability 'tilt'
critcl::source kt_cap_zoom.tcl          ; # capability 'zoom'

# # ## ### ##### ######## #############
## Make the C pieces ready. Immediate build of the binaries, no deferal.

if {![critcl::load]} {
    error "Building and loading KineTcl failed."
}

# # ## ### ##### ######## #############

package provide kinetcl 0
return

# vim: set sts=4 sw=4 tw=80 et ft=tcl:
