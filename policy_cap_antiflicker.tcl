## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'CapAntiflicker' wrapping around
## the C level class 'CapAntiflickerC'.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

namespace eval ::kinetcl {}

# # ## ### ##### ######## #############

oo::class create ::kinetcl::CapAntiflicker {
    constructor {} {
	::kinetcl::CapAntiflickerC create CAP
	return
    }

    # # ## ### ##### ######## #############
    ## Tcl wrapper for argument handling.

    method frequency {{frequency {}}} {
	if {[llength [info level 0]] == 3} {
	    CAP @frequency: $freq
	}
	CAP @frequency?
    }

    # # ## ### ##### ######## #############

    # Expose the basic methods, and a few of the normally excluded
    # special methods. Capability wrapper classes should pretty much
    # look like their C class.

    kinetcl::Publish ::kinetcl::CapAntiflickerC CAP
    forward methods CAP methods
    forward @self   CAP @self
    export  @self ;# Doesn't fit the pattern of method names exported by default

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
