## -*- tcl -*-
# # ## ### ##### ######## ############# #####################

## This file defines a TclOO class serving as adapter between kinetcl
## skeleton/joint data (as provided by kinetcl::joints) and a canvas,
## drawing the joints of all users currently known, tracking them in
## real time. Beyond the joints instance a depth map generator is
## required as well, for the conversion from real-world to screen
## coordinates.

# # ## ### ##### ######## ############# #####################
## Requirements

package require kinetcl
package require TclOO
package require oo::util ; # tcllib, mymethod.
package require canvas::tag

# # ## ### ##### ######## ############# #####################

oo::class create ::kinetcl::canvas::joints {
    # # ## ### ##### ######## ############# #####################

    constructor {canvas depth joints} {
	kinetcl::validate $depth

	set mycanvas $canvas
	set mydepth  $depth
	set myloc    {}

	::kinetcl::eventbindings create JOINTS $joints
	JOINTS bind joint-create  [mymethod JointCreate]
	JOINTS bind joint-move    [mymethod JointMove]
	JOINTS bind joint-destroy [mymethod JointDestroy]

	set mycreatecmd [mymethod DefaultCreate]
	return
    }

    destructor {
	JOINTS unbind
	$mycanvas delete [self]
	return
    }

    # # ## ### ##### ######## ############# #####################
    ## 

    # xxx set/get createcmd ... custom joint visualization.

    # # ## ### ##### ######## ############# #####################
    ##

    method JointCreate {__event __joints details} {
	dict with details {} ; # ==> user joint position
	set tag [my Tag $user $joint]
	set pos [lrange [lindex [$mydepth world2projective $position] 0] 0 1]

	# Generate visual representation
	set items [{*}$mycreatecmd $mycanvas {*}$pos]

	# Tag it (global, and user/joint specific)
	foreach item $items {
	    canvas::tag append $mycanvas $item \
		[self] $tag
	}

	# Save current location for incremental movement later.
	dict set myloc $tag $pos
	return
    }

    method JointMove {__event __joints details} {
	dict with details {} ; # ==> user joint position
	set tag [my Tag $user $joint]
	set pos [lrange [lindex [$mydepth world2projective $position] 0] 0 1]

	lassign [dict get $myloc $tag] ox oy
	lassign $pos                   nx ny

	set dx [expr {$nx - $ox}]
	set dy [expr {$ny - $oy}]

	$mycanvas move $tag $dx $dy
	dict set myloc $tag $pos
	return
    }

    method JointDestroy {__event __joints details} {
	dict with details {} ; # ==> user joint
	set tag [my Tag $user $joint]

	$mycanvas delete $tag
	dict unset myloc $tag
	return
    }

    # # ## ### ##### ######## ############# #####################

    method Tag {u j} {
	return [list [self] $u $j]
    }

    # # ## ### ##### ######## ############# #####################

    method DefaultCreate {canvas x y} {
	# Standard joint representation. Filled red circle, radius 5,
	# centered at the joint location.
	lappend items [$canvas create oval {*}[my Box $x $y] \
			   -width   1    \
			   -outline red  \
			   -fill    red]
	return $items
    }

    method Box {x y} {
	set w [expr {$x - 5}]
	set n [expr {$y - 5}]
	set e [expr {$x + 5}]
	set s [expr {$y + 5}]
	return [list $w $n $e $s]
    }

    # # ## ### ##### ######## ############# #####################
    ## State
    #
    ## - The canvas to draw on.
    ## - The depth (map) generator for coordinate conversions
    ## - Command prefix to generate visual joint representations.
    ## - Joint location, for incremental movement.

    variable mycanvas mydepth mycreatecmd myloc

    # # ## ### ##### ######## ############# #####################
}

# # ## ### ##### ######## ############# #####################

namespace eval ::kinetcl {
    namespace eval canvas {
	namespace export joints
	namespace ensemble create
    }
    namespace export canvas
    namespace ensemble create
}

package provide kinetcl::canvas::joints 0
return
