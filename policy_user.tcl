## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'user' wrapping around the C level
## class 'User' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::user {
    superclass ::kinetcl::generator

    # user ==> generator ==> base
    #      +-> skeleton
    #      +-> pose detection
    #      +-> hand touching fov

    constructor {} {
	::kinetcl::User create USER
	# Stashes C handle in global data structures
	next
	USER @unmark ; # Clear the stash
	return
    }

    kinetcl::Publish ::kinetcl::User USER
}

# # ## ### ##### ######## #############
