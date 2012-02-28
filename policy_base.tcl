## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'base' wrapping around the C level
## class 'Base' and its associated. The code here glues the C pieces
## together into a whole.

## It additionally provides some shared helper commands.

# # ## ### ##### ######## #############

package require TclOO

namespace eval ::kinetcl {}

# # ## ### ##### ######## #############
## Required by the class defitinio(s), define before.

proc ::kinetcl::Publish {class component {exclude {}}} {
    set methods [uplevel 1 [list $class methods]]
    #puts "$class $component = ($methods)"
    foreach m $methods {
	if {$m in {destroy methods @unmark}} continue
	if {$m in $exclude} continue
	uplevel 1 [list forward $m $component $m]
    }
    return
}

# # ## ### ##### ######## #############

oo::class create ::kinetcl::base {
    # +-> error state
    # +-> general int

    constructor {} {
	# Pulls C handle out of stash,
	::kinetcl::Base create BASE

	# Check the handle for capabilities, create their C instances,
	# and expose all the provided methods
	foreach cap [my capabilities] {
	    set class [my CapabilityClass $cap]
	    ::kinetcl::$class create I$class
	    my CapabilityPublish     I$class
	}
	return
    }

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
	    if {$m in {destroy methods @unmark}} continue
	    if {$m in $exclude} continue
	    oo::objdefine [self] forward $m $component $m
	}
	return
    }

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

    # Expose the base methods.
    kinetcl::Publish ::kinetcl::Base BASE \
	{capabilities}
}

# # ## ### ##### ######## #############
