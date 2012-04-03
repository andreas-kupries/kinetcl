## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'depth' wrapping around the C level
## class 'Depth' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::depth {
    superclass ::kinetcl::map

    # depth ==> map ==> generator ==> base
    #       +-> user position

    constructor {} {
	::kinetcl::Depth create DEPTH
	# Stashes C handle in global data structures
	DEPTH @self [self]
	next
	BASE @unmark ; # Clear the stash
	my SetupEventsOf DEPTH
	return
    }

    kinetcl::Publish ::kinetcl::Depth DEPTH
}

# # ## ### ##### ######## #############
