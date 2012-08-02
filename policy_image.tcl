## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'image' wrapping around the C level
## class 'Image' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::image {
    superclass ::kinetcl::map

    # image ==> map ==> generator ==> base

    constructor {} {
	::kinetcl::Image create IMAGE
	# Stashes C handle in global data structures
	IMAGE @self [self]
	next
	BASE @unmark ; # Clear the stash
	my SetupEventsOf IMAGE
	return
    }

    method format {{format {}}} {
	if {[llength [info level 0]] == 3} {
	    IMAGE @format: $format
	}
	IMAGE @format?
    }

    kinetcl::Publish ::kinetcl::Image IMAGE
}

# # ## ### ##### ######## #############
