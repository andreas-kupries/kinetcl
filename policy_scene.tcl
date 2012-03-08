## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'scene' wrapping around the C level
## class 'Scene' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::scene {
    superclass ::kinetcl::map

    # scene ==> map ==> generator ==> base

    constructor {} {
	::kinetcl::Scene create SCENE
	# Stashes C handle in global data structures
	SCENE @self [self]
	next
	BASE @unmark ; # Clear the stash
	return
    }

    kinetcl::Publish ::kinetcl::Scene SCENE
}

# # ## ### ##### ######## #############
