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

critcl::tsources policy.tcl

# # ## ### ##### ######## #############
## Main C section.

# # ## ### ##### ######## #############
## C classes for the various types of objects.

critcl::source support.tcl ; # Build-time helper commands.

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
## Make the C pieces ready. Immediate build of the binaries, no deferal.

if {![critcl::load]} {
    error "Building and loading KineTcl failed."
}

# # ## ### ##### ######## #############

package provide kinetcl 0
return

# vim: set sts=4 sw=4 tw=80 et ft=tcl:
