## -*- tcl -*-
# # ## ### ##### ######## #############
## This file defines a number of commands on top of the C primitives
## which are easier to use than directly calling on the latter.

# # ## ### ##### ######## #############
## Simply place the toplevel commands into an ensemble.

namespace eval ::kinetcl {
    namespace export \
	audio depth gesture hands image ir player \
	recorder script user scene \
	\
	start stop waitUpdate waitOneUpdate \
	waitAnyUpdate waitNoneUpdate errorstate

    namespace ensemble create

    # Dictionary of known kinetcl instances, Managed by kinetcl::base
    # constructors and destructors. Enables the validation of
    # arguments as kinetcl objects, and their conversion into C-level
    # OpenNI handles.
    variable known {}
}

# # ## ### ##### ######## #############
return
