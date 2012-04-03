## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class managing bindings for someone else.

# # ## ### ##### ######## #############

package require TclOO
package require oo::util   ; # mymethod
package require uevent 0.3 ; # Tcllib, (un)bind watching.

# # ## ### ##### ######## #############

namespace eval ::kinetcl {}

# # ## ### ##### ######## #############
## Required by the class defitinio(s), define before.

# # ## ### ##### ######## #############

oo::class create ::kinetcl::eventbindings {

    constructor {obj} {
	set myobj      $obj
	set mybindings {}
	return
    }

    destructor {
	my unbind
	return
    }

    # # ## ### ##### ######## #############
    ## Public per-instance binding API.

    method bind {event cmd} {
	lappend mybindings [uplevel 1 [list $myobj bind $event $cmd]]
	return
    }

    method unbind {} {
	foreach token $mybindings {
	    $myobj unbind $token
	}
	set mybindings {}
	return
    }

    # # ## ### ##### ######## #############
    ## Instance state
    #
    ## myobj      :: instance command, the object we are binding to.
    ## mybindings :: list (token), for removal of the bindings later.

    variable myobj mybindings

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
