## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'base' wrapping around the C level
## class 'Base' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

## It additionally provides a number of shared helper commands.

# # ## ### ##### ######## #############

namespace eval ::kinetcl {}

proc ::kinetcl::Publish {classOrInstance component {exclude {}}} {
    set methods [uplevel 1 [list $classOrInstance methods]]
    #puts "$classOrInstance $component = ($methods)"
    foreach m $methods {
	if {$m in {destroy methods @unmark}} continue
	if {$m in $exclude} continue
	uplevel 1 [list forward $m $component $m]
    }
    return
}

proc ::kinetcl::CapClass {cap} {
    set class Cap
    foreach c [split $cap -] {
	append class [string totitle $c]
    }
    return $class
}

proc ::kinetcl::MixCapabilities {args} {
    foreach cap $args {
	if {![uplevel 1 [list my is-capable-of $cap]]} continue
	set class [CapClass $cap]
	uplevel 1 [list ::kinetcl::$class create I$class]
	uplevel 1 [list ::kinetcl::Publish I$class I$class]
    }
    return
}

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::base {
    # +-> error state
    # +-> general int

    constructor {} {
	# Pulls C handle out of stash,
	::kinetcl::Base create BASE
	kinetcl::MixCapabilities ; # ...
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

    kinetcl::Publish ::kinetcl::Base BASE \
	{capabilities}
}

# # ## ### ##### ######## #############
