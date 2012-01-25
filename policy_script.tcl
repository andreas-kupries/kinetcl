## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'script' wrapping around the C level
## class 'Script' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::script {
    superclass ::kinetcl::base

    # script ==> base

    constructor {} {
	::kinetcl::Script create MY
	# Stashes C handle in global data structures
	next
	MY @unmark ; # Clear the stash
	return
    }

    kinetcl::Publish ::kinetcl::Script
}

# # ## ### ##### ######## #############
