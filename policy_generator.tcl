## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'generator' wrapping around the C
## level class 'Generator' and its associated superclasses and aspects. The
## code here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::generator {
    superclass ::kinetcl::base

    # generator ==> base
    #           +-> mirror
    #           +-> alternative viewpoint
    #           +-> frame-sync

    constructor {} {
	# Pulls C handle out of stash,
	::kinetcl::Generator create MY
	next
	kinetcl::MixCapabilities ; # ...
	return
    }

    kinetcl::Publish ::kinetcl::Generator
}

# # ## ### ##### ######## #############
