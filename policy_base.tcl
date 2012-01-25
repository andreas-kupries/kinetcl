## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'base' wrapping around the C level
## class 'Base' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

## It additionally provides a number of shared helper commands.

# # ## ### ##### ######## #############

namespace eval ::kinetcl {}

proc ::kinetcl::Publish {classOrInstance {component MY}} {
    foreach m [$classOrInstance methods] {
	if {$m ni {destroy methods @unmark}} continue
	forward $m $component $m
    }
    return
}

proc ::kinetcl::MixCapabilities {args} {
    foreach cap $args {
	if {![uplevel 1 [list my isCapableOf $cap]]} continue
	uplevel 1 [list ::kinetcl::CAP$cap create C$cap]
	uplevel 1 [list ::kinetcl::Publish C$cap C$cap]
    }
    return
}

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::base {

    # +-> error state
    # +-> general int

    constructor {} {
	# Pulls C handle out of stash,
	::kinetcl::Base create MY
	kinetcl::MixCapabilities ; # ...
	return
    }

    kinetcl::Publish ::kinetcl::Base
}

# # ## ### ##### ######## #############
