## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'audio' wrapping around the C level
## class 'Audio' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::audio {
    superclass ::kinetcl::generator

    # audio ==> generator ==> base

    constructor {} {
	::kinetcl::Audio create MY
	# Stashes C handle in global data structures
	next
	MY @unmark ; # Clear the stash
	return
    }

    kinetcl::Publish ::kinetcl::Audio
}

# # ## ### ##### ######## #############
