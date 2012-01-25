## -*- tcl -*-
# # ## ### ##### ######## #############
## This file defines a number of commands on top of the C primitives
## which are easier to use than directly calling on the latter.

# # ## ### ##### ######## #############
## Simply place the toplevel commands into an ensemble.

namespace eval ::kinetcl {
    namespace export \
	audio depth gesture hands image ir player \
	recorder script user
    namespace ensemble create
}

# # ## ### ##### ######## #############
return
