## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'recorder' wrapping around the C level
## class 'Recorder' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::recorder {
    superclass ::kinetcl::base

    # recorder ==> base

    constructor {} {
	::kinetcl::Recorder create RECORDER
	# Stashes C handle in global data structures
	RECORDER @self [self]
	next
	BASE @unmark ; # Clear the stash
	my SetupEventsOf RECORDER
	return
    }

    kinetcl::Publish ::kinetcl::Recorder RECORDER
}

# # ## ### ##### ######## #############
