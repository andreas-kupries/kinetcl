## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'hands' wrapping around the C level
## class 'Hands' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::hands {
    superclass ::kinetcl::generator

    # hands ==> generator ==> base

    constructor {} {
	::kinetcl::Hands create HANDS
	# Stashes C handle in global data structures
	HANDS @self [self]
	next
	BASE @unmark ; # Clear the stash
	my SetupEventsOf HANDS
	return
    }

    kinetcl::Publish ::kinetcl::Hands HANDS
}

# # ## ### ##### ######## #############
