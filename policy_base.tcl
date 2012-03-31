## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'base' wrapping around the C level
## class 'Base' and its associated. The code here glues the C pieces
## together into a whole.

## It additionally provides some shared helper commands.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

namespace eval ::kinetcl {}

# # ## ### ##### ######## #############
## Required by the class defitinio(s), define before.

proc ::kinetcl::Publish {class component {exclude {}}} {
    set methods [uplevel 1 [list $class methods]]
    #puts "$class $component = ($methods)"
    foreach m $methods {
	# introspection, destruction controlled by wrapper
	if {$m in {destroy methods}} continue
	# special methods must not be seen.
	if {[string match @* $m]} continue
	# callbacks are internal, managed to outside as events (uevent).
	if {[string match unset-callback-* $m]} continue
	if {[string match set-callback-* $m]} continue
	if {$m in $exclude} continue
	uplevel 1 [list forward $m $component $m]
    }
    return
}

proc ::kinetcl::Valid {o} {
    # Check if o is a proper kinetcl object.  If yes, directly access
    # the internal BASE object and have it stash the handle for use by
    # other methods.  These methods are responsible for un-stashing
    # the handle after use.

    variable known
    set cmd [uplevel 1 [list namespace which -command $o]]

    if {![dict exists $known  $cmd]} {
	return -code error -errorcode {KINETCL INVALID INSTANCE} \
	    "Expected kinetcl instance, got \"$o\""
    }

    # Directly access the instance internals to put the object's
    # OpenNI handle into the standard shared location.
    [info object namespace $o]::BASE @mark
    return
}

# # ## ### ##### ######## #############

oo::class create ::kinetcl::base {
    superclass ::kinetcl::nodeevents

    # +-> error state
    # +-> general int

    constructor {} {
	next

	# Pulls C handle out of stash,
	::kinetcl::Base create BASE
	BASE @self [self]
	my SetupEventsOf BASE

	# Check the handle for capabilities, create their C instances,
	# and expose all the provided methods
	foreach cap [my capabilities] {
	    set class [my CapabilityClass $cap]
	    ::kinetcl::$class create I$class
	    my CapabilityPublish     I$class
	    my SetupEventsOf         I$class
	    I$class @self [self]
	}

	# Remember the instance for validation
	variable ::kinetcl::known
	dict set known [self] .
	return
    }

    destructor {
	# Remove the instance from the validation database.
	variable ::kinetcl::known
	dict unset known [self]
	return
    }

    # # ## ### ##### ######## #############
    method capabilities {args} {
	if {([llength $args] == 1) &&
	    ([lindex $args 0] eq "-all")} {
	    return [lsort -dict [BASE capabilities]]
	}
	if {[llength $args] == 0} {
	    set result {}
	    foreach c [BASE capabilities] {
		if {![BASE is-capable-of $c]} continue
		lappend result $c
	    }
	    return [lsort -dict $result]
	}

	return -code error \
	    "wrong#args: expected [self] capabilities ?-all?"
    }

    # # ## ### ##### ######## #############
    method CapabilityClass {cap} {
	set class Cap
	foreach c [split $cap -] {
	    append class [string totitle $c]
	}
	return $class
    }

    method CapabilityPublish {component {exclude {}}} {
	set methods [$component methods]
	#puts "$component = ($methods)"
	foreach m $methods {
	    if {$m in {destroy methods}} continue
	    if {[string match @* $m]} continue
	    if {$m in $exclude} continue
	    oo::objdefine [self] forward $m $component $m
	}
	return
    }

    # # ## ### ##### ######## #############
    # Expose the base methods.

    kinetcl::Publish ::kinetcl::Base BASE \
	{capabilities}
    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
