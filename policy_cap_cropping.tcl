## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'CapCropping' wrapping around
## the C level class 'CapCroppingC'.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

namespace eval ::kinetcl {}

# # ## ### ##### ######## #############

oo::class create ::kinetcl::CapCropping {
    constructor {} {
	::kinetcl::CapCroppingC create CAP
	return
    }

    # # ## ### ##### ######## #############
    ## Tcl wrapper for argument handling.

    method crop {{x {}} {y {}} {w {}} {h {}}} {
	set n [llength [info level 0]]
	if {$n == 6} {
	    CAP @crop: $x $y $w $h
	} elseif {$n != 2} {
	    return -code error "wrong\#args: ?x y w h?"
	}
	CAP @crop?
    }

    # # ## ### ##### ######## #############

    # Expose the basic methods, and a few of the normally excluded
    # special methods. Capability wrapper classes should pretty much
    # look like their C class.

    kinetcl::Publish ::kinetcl::CapCroppingC CAP
    forward methods CAP methods
    forward @self   CAP @self
    export  @self ;# Doesn't fit the pattern of method names exported by default

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
