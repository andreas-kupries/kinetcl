## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'CapMirror' wrapping around the C
## level class 'CapMirrorC'.

## It additionally provides some shared helper commands.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

namespace eval ::kinetcl {}

# # ## ### ##### ######## #############

oo::class create ::kinetcl::CapMirror {
    constructor {} {
	::kinetcl::CapMirrorC create CAP
	return
    }

    # # ## ### ##### ######## #############
    ## Tcl wrapper for argument handling.

    method mirror {{on {}}} {
	if {[llength [info level 0]] == 3} {
	    CAP @mirror: $on
	}
	CAP @mirror?
    }

    # # ## ### ##### ######## #############

    # Expose the basic methods, and a few of the normally excluded
    # special methods. Capability wrapper classes should pretty much
    # look like their C class.

    kinetcl::Publish ::kinetcl::CapMirrorC CAP
    forward methods CAP methods
    forward @self   CAP @self
    export  @self ;# Doesn't fit the pattern of method names exported by default

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
