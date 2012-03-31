## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class managing instances as event
## generators. The underlying event system is Tcllib's uevent.

# # ## ### ##### ######## #############

package require TclOO
package require oo::util   ; # mymethod
package require uevent 0.3 ; # Tcllib, (un)bind watching.

# # ## ### ##### ######## #############

namespace eval ::kinetcl {}

# # ## ### ##### ######## #############
## Required by the class defitinio(s), define before.

# # ## ### ##### ######## #############

oo::class create ::kinetcl::eventbase {

    constructor {} {
	set myself   [uevent watch tag add [self] [mymethod Generator]]
	set myevents {}
	return
    }

    destructor {
	my Done
	return
    }

    # # ## ### ##### ######## #############
    ## Public per-instance binding API.

    method bind {event cmdprefix} {
	return [uevent bind [self] $event $cmdprefix]
	# May come back to us via Generator/Generate, to activate
	# actual event generation when actually observed.
    }

    method unbind {token} {
	return [uevent unbind $token]
	# May come back to us via Generator/Generate, to deactivate
	# actual event generation when not observed.
    }

    # # ## ### ##### ######## #############
    ## Public virtual methods.
    ## Override in subclasses.
    #
    ## Invoked from Generator/Generate, below.

    method bound   {} {}
    method unbound {} {}

    method event-bound   {e} {}
    method event-unbound {e} {}

    # # ## ### ##### ######## #############
    ## Instance state
    #
    ## myself   :: uevent tag token, watching (un)binding on the
    ##             instance as tag.
    ## myevents :: list (uevent event token), watching the (un)binding
    ##             on instance (as tag)/event combinations.

    variable myself myevents

    # # ## ### ##### ######## #############
    ## Internal: Extend the set of events to watch,
    ##           and removal of all our watchers.

    method Register {events} {
	foreach e $events {
	    set token [uevent watch event add [self] $e [mymethod Generate]]
	    lappend myevents $token
	}
	return
    }

    method Done {} {
	foreach token $myevents {
	    uevent watch event remove $token
	}
	uevent watch tag remove $myself
	return
    }

    # # ## ### ##### ######## #############
    ## Internal: uevent watch callbacks.

    method Generator {action __} {
	# __ == tag == [self]
	# assert ($action in {bound unbound})

	my $action
	return
    }

    method Generate {action __ event} {
	# __ == tag == [self]
	# assert ($action in {bound unbound})

	my event-$action $event
	return
    }

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
