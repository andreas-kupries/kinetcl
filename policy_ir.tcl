## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'ir' wrapping around the C level
## class 'Ir' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::ir {
    superclass ::kinetcl::map

    # ir ==> map ==> generator ==> base

    constructor {} {
	::kinetcl::Ir create IR
	# Stashes C handle in global data structures
	IR @self [self]
	next
	BASE @unmark ; # Clear the stash
	my SetupEventsOf IR
	return
    }

    kinetcl::Publish ::kinetcl::Ir IR
}

# # ## ### ##### ######## #############
