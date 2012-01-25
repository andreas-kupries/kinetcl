## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'gesture' wrapping around the C level
## class 'Gesture' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::gesture {
    superclass ::kinetcl::generator

    # gesture ==> generator ==> base

    constructor {} {
	::kinetcl::Gesture create MY
	# Stashes C handle in global data structures
	next
	MY @unmark ; # Clear the stash
	return
    }

    kinetcl::Publish ::kinetcl::Gesture
}

# # ## ### ##### ######## #############
