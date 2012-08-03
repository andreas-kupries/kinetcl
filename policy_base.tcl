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
## Required by the class definition(s), define before.

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
    # ATTENTION: This procedure is used by the C-level
    # See function kinetcl_validate(), file kt_context.tcl).

    # Check if O is a proper kinetcl object.  If yes, directly access
    # the internal BASE object and have it stash the handle for use by
    # other methods.  These methods are responsible for un-stashing
    # the handle after use.

    # Our database is a namespace-global dictionary used as a set (of
    # its keys).  Its content is managed by the kinetcl::base class
    # constructor and destructor.  See marker [KV].

    variable known
    set cmd [uplevel 1 [list namespace which -command $o]]

    if {![dict exists $known $cmd]} {
	return -code error -errorcode {KINETCL INVALID INSTANCE} \
	    "Expected kinetcl instance, got \"$o\""
    }

    # Directly access the instance internals to put the object's
    # OpenNI handle into the standard shared location. This part is
    # for use by the C-level kinetcl_validate() calling out to us, to
    # allow not just validation, but conversion.

    [info object namespace $o]::BASE @mark
    return
}

# # ## ### ##### ######## #############

proc ::kinetcl::validate {o} {
    # First validate as kinetcl node. Raises error on non-validation.
    # Then clear the C-level information this left behind.
    Valid $o
    [info object namespace $o]::BASE @unmark
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

	# [KV] Remember the instance for validation --> See kinetcl::Valid.
	variable ::kinetcl::known
	dict set known [self] .
	return
    }

    destructor {
	# [KV] Drop the instance from validation --> See kinetcl::Valid.
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
