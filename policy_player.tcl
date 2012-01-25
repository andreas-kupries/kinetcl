## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'player' wrapping around the C level
## class 'Player' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::player {
    superclass ::kinetcl::base

    # player ==> base

    constructor {} {
	::kinetcl::Player create MY
	# Stashes C handle in global data structures
	next
	MY @unmark ; # Clear the stash
	return
    }

    kinetcl::Publish ::kinetcl::Player
}

# # ## ### ##### ######## #############
