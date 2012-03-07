## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'map' wrapping around the C level
## class 'Map' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::map {
    superclass ::kinetcl::generator

    # map ==> generator ==> base
    #     +-> cropping
    #     +-> anti-flicker

    constructor {} {
	# Pulls C handle out of stash,
	::kinetcl::Map create MAP
	MAP @self [self]
	next
	return
    }

    kinetcl::Publish ::kinetcl::Map MAP
}

# # ## ### ##### ######## #############
