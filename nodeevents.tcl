## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class managing kinetcl node instances as
## event generators. Based on the "eventbase" it provides the connectivity
## to the kinetcl C classes and their callbacks.

# # ## ### ##### ######## #############

package require TclOO
package require oo::util   ; # mymethod
package require uevent

# # ## ### ##### ######## #############

namespace eval ::kinetcl {}

# # ## ### ##### ######## #############
## Required by the class defitinio(s), define before.

# # ## ### ##### ######## #############

oo::class create ::kinetcl::nodeevents {
    superclass ::kinetcl::eventbase

    constructor {} {
	array set myeventmap  {}
	next
	return
    }

    destructor {}

    # # ## ### ##### ######## #############

    variable myeventmap

    # # ## ### ##### ######## #############
    ## Extract the events known to the C node class from the set of
    ## its methods ((un)set-callback-*), and register them in the
    ## base.

    method SetupEventsOf {node} {
	set events {}
	foreach m [$node methods] {
	    if {![string match set-callback-* $m]} continue
	    set event [string map {set-callback- {}} $m]
	    lappend events $event
	    set myeventmap($event) $node
	}

	my Register $events
	return
    }

    # # ## ### ##### ######## #############
    ## Event specific watchers, overriden from eventbase. Translate
    ## from event (non)observation to the (de)activation of the
    ## callback actually generating said event.

    method event-bound {e} {
	set node $myeventmap($e)
	$node set-callback-$e [mymethod Broadcast]
	return
    }

    method event-unbound {e} {
	set node $myeventmap($e)
	$node set-uncallback-$e
	return
    }

    # # ## ### ##### ######## #############
    ## General callback receiver translating into a distributed
    ## (u)event.

    method Broadcast {event obj details} {
	uevent generate $obj $event $details
	return
    }

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
