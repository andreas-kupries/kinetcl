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
	::kinetcl::Audio create AUDIO
	AUDIO @self [self]
	# Stashes C handle in global data structures
	next
	BASE @unmark ; # Clear the stash
	my SetupEventsOf AUDIO
	return
    }

    kinetcl::Publish ::kinetcl::Audio AUDIO
}

# # ## ### ##### ######## #############
