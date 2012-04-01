## -*- tcl -*-
# # ## ### ##### ######## ############# #####################

## This file defines a TclOO class serving as adapter between kinetcl
## skeleton/joint data (as provided by kinetcl::joints) and a canvas,
## drawing the skeleton _lines_ of all users currently known, tracking
## them in real time. Beyond the joints instance a depth map generator
## is required as well, for the conversion from real-world to screen
## coordinates.

# # ## ### ##### ######## ############# #####################
## Requirements

package require kinetcl
package require TclOO
package require oo::util ; # tcllib, mymethod.
package require canvas::tag

# # ## ### ##### ######## ############# #####################

oo::class create ::kinetcl::canvas::skeleton {

    # # ## ### ##### ######## ############# #####################
    constructor {canvas depth joints} {
	kinetcl::validate $depth

	my JointMap ; # Execution and data should be class-level.
	set mycanvas $canvas
	set mydepth  $depth
	set myjoints $joints
	set myloc    {}

	lappend mybindings [$joints bind joint-create  [mymethod JointCreate]]
	lappend mybindings [$joints bind joint-move    [mymethod JointMove]]
	lappend mybindings [$joints bind joint-destroy [mymethod JointDestroy]]

	set mycreatecmd [mymethod DefaultCreate]
	return
    }

    destructor {
	# Remove the bindings and destroy all items we owned
	foreach token $mybindings { $myjoint unbind $token }
	$mycanvas delete [self]
	return
    }

    # # ## ### ##### ######## ############# #####################
    ## 

    # xxx set/get createcmd ... custom line visualization.

    # # ## ### ##### ######## ############# #####################
    ##

    method JointCreate {__event __joints details} {
	dict with details {} ; # ==> user joint position
	set key [my Key $user $joint]
	set pos [lrange [lindex [$mydepth world2projective $position] 0] 0 1]

	# Save the joint location.
	dict set myloc $key $pos

	# Determine the lines the new joint should be a part of and
	# create those for which the neighbouring joint exists as
	# well.
	foreach njoint [dict get $myjointmap $joint] {
	    set nkey [my Key $user $njoint]
	    if {![dict exists $myloc $nkey]} continue

	    set tag  [my Tag $user $joint $njoint]
	    set npos [dict get $myloc $nkey]

	    # Generate visual representation
	    set items [{*}$mycreatecmd $mycanvas {*}$pos {*}$npos]

	    # Tag it (global, and user/joint specific)
	    foreach item $items {
		canvas::tag append $mycanvas $item \
		    [self] $tag
	    }
	}
	return
    }

    method JointMove {__event __joints details} {
	dict with details {} ; # ==> user joint position
	set key [my Key $user $joint]
	set pos [lrange [lindex [$mydepth world2projective $position] 0] 0 1]

	dict set myloc $key $pos

	# Determine the lines the moved joint is a part of and update
	# the location of those which actually exist
	foreach njoint [dict get $myjointmap $joint] {
	    set nkey [my Key $user $njoint]
	    if {![dict exists $myloc $nkey]} continue

	    set tag  [my Tag $user $joint $njoint]
	    set npos [dict get $myloc $nkey]

	    $mycanvas coords $tag {*}$pos {*}$npos
	}
	return
    }

    method JointDestroy {__event __joints details} {
	dict with details {} ; # ==> user joint

	# Remove joint information ...
	dict unset myloc [my Key $user $joint]

	# ... and all lines it is part of.
	foreach njoint [dict get $myjointmap $joint] {
	    set tag [my Tag $user $joint $njoint]
	    $mycanvas delete $tag
	}
	return
    }

    # # ## ### ##### ######## ############# #####################

    method Key {u j} {
	return [list $u $j]
    }

    method Tag {u ja jb} {
	return [list [self] $u [lsort -dict [list $ja $jb]]]
    }

    method JointMap {} {
	# This should be run only once, class-level.

	# Transform list of skeleton lines into a map from each joint
	# to the adjacent joints. In the joint event handlers we can
	# then quickly go from the modified joint to the set of joints
	# to manipulate.
	#
	# Not used: fingertips, wrists, ankles, collars, and waist.

	foreach {s e} {
	    left-hand       left-elbow
	    left-elbow      left-shoulder
	    left-shoulder   torso
	    left-shoulder   neck

	    left-foot       left-knee
	    left-knee       left-hip
	    left-hip        torso

	    right-hand      right-elbow
	    right-elbow     right-shoulder
	    right-shoulder  torso
	    right-shoulder  neck

	    right-foot      right-knee
	    right-knee      right-hip
	    right-hip       torso

	    head            neck
	    left-hip        right-hip
	} {
	    dict lappend myjointmap $s $e
	    dict lappend myjointmap $e $s
	}
	return
    }

    # # ## ### ##### ######## ############# #####################

    method DefaultCreate {canvas x0 y0 x1 y1} {
	# Standard representation of skeleton line. Filled light blue
	# line, width 5, from joint to joint.
	lappend items [$mycanvas create line $x0 $y0 $x1 $y1 \
			   -width 5 \
			   -fill lightblue]
	return $items
    }

    # # ## ### ##### ######## ############# #####################
    ## State
    #
    ## - The canvas to draw on.
    ## - The depth (map) generator for coordinate conversions
    ## - The joint tracker delivering us events
    ## - The bindings set on the joints tracker, for proper destruction.
    ## - Command prefix to generate visual joint representations.
    ## - Joint location, for incremental movement.

    variable mycanvas mydepth myjoints mybindings mycreatecmd myloc \
	myjointmap

    # # ## ### ##### ######## ############# #####################
}

# # ## ### ##### ######## ############# #####################

namespace eval ::kinetcl {
    namespace eval canvas {
	namespace export skeleton
	namespace ensemble create
    }
    namespace export canvas
    namespace ensemble create
}

package provide kinetcl::canvas::skeleton 0
return
