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
	array set myactivemap {}
	next
	return
    }

    destructor {}

    # # ## ### ##### ######## #############

    variable myeventmap myactivemap

    # # ## ### ##### ######## #############

    method SetupEventsOf {node} {
	set events {}
	foreach m [$o methods] {
	    if {![string match set-callback-* $m]} continue
	    set event [string map {set-callback- {}} $m]
	    lappend events $event
	    set myeventmap($event) $node
	}

	my Register $events
	return
    }

    # # ## ### ##### ######## #############
    ## Overridden event specific watchers.
    ## Translation of event (non)observation into (de)activation of
    ## their actual generating callbacks.

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

    method Broadcast {event obj details} {
	uevent generate $obj $event $details
    }

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
