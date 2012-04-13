## -*- tcl -*-
# # ## ### ##### ######## ############# #####################

## This file defines a TclOO class storing information about a stance,
## and able to check for users entering and exixting said stance. For
## the latter a stance instance must be connected to an instance of
## class [kinetcl joints].

# # ## ### ##### ######## ############# #####################

package require TclOO
package require oo::util ; # tcllib, mymethod.

# # ## ### ##### ######## ############# #####################

oo::class create ::kinetcl::stance {
    superclass ::kinetcl::eventbase

    # # ## ### ##### ######## ############# #####################
    ## Lifecycle

    constructor {joints} {
	next
	my Register {stance-enter stance-exit}
	set myjoints  $joints
	set mydef     {}
	set mystatus  {}
	set mymeasure {}

	kinetcl::eventbindings create JOINTS $joints

	# Make the DSL command available to the instance namespace,
	# which is where the stance definitions are run. See method
	# 'add' for details.

	namespace path [linsert [namespace path] end ::kinetcl::stance::dsl]

	# Define a series of standard mesaures.
	my measure left-neck-length       { distance left-shoulder  neck        }
	my measure left-upper-arm-length  { distance left-shoulder  left-elbow  }
	my measure left-lower-arm-length  { distance left-hand      left-elbow  }

	my measure right-neck-length      { distance right-shoulder neck        }
	my measure right-upper-arm-length { distance right-shoulder right-elbow }
	my measure right-lower-arm-length { distance right-hand     right-elbow }

	my measure neck-length      { min [left-neck-length]      [right-neck-length]      }
	my measure upper-arm-length { min [left-upper-arm-length] [right-upper-arm-length] }
	my measure lower-arm-length { min [left-lower-arm-length] [right-lower-arm-length] }
	return
    }

    destructor {
	my unbound

	# Further set all stances of all users to off, generating the
	# proper events where needed. IOW last call.

	foreach user [dict keys $mystatus] {
	    foreach stance [dict keys $mydef] {
		my StanceStatus $user $stance off
	    }
	}
	return
    }

    # # ## ### ##### ######## ############# #####################

    method bound {} {
	# Track skeleton changes. On a per-user basis, we do not ewish
	# to run a stance-check for every joint change of the
	# user-change, only the whole user.

	JOINTS bind user-create  [mymethod UserCreate]
	JOINTS bind user-move    [mymethod UserMove]
	JOINTS bind user-destroy [mymethod UserDestroy]
	return
    }

    method unbound {} {
	JOINTS unbind
	return
    }

    # # ## ### ##### ######## ############# #####################
    ## Stance (un)definition.

    method add {name script} {
	# Prevent re-definition of existing stance
	if {[dict exists $mydef $name]} {
	    return -code error -errorcode {} \
		"Unable to define stance \"$name\", already exists"
	}

	# Stance definitions are run in the context of the instance
	# namespace, to have access to the defined measure(ment)s. The
	# DSL commands are accessible there as well. See the
	# constructor.

	dict set mydef $name \
	    [list apply \
		 [list {} $script [info object namespace [self]]]]

	# Initialize the stance's status for all known users
	foreach user [dict keys $mystatus] {
	    dict set mystatus $user $name off
	}
	return
    }

    method remove {name} {
	# Prevent removal of unknown stance.
	if {![dict exists $mydef $name]} {
	    return -code error -errorcode {} \
		"Unable to remove stance \"$name\", does not exist"
	}

	dict unset mydef $name

	# Drop the stance's status for all known users, possibly
	# sending out the proper deactivation events.
	foreach user [dict keys $mystatus] {
	    my StanceStatus $user $name off
	    dict unset mystatus $user $name
	}
	return
    }

    # # ## ### ##### ######## ############# #####################
    ## Define measures. This are distances which are reasonably
    ## unchanging for a skeleton during its life, making them
    ## cacheable.

    method measure {name script} {
	# Saved as accessor procedure in the object namespace.
	# Delegates the main work to a helper command defined in the
	# DSL support namespace.

	lappend map @n $name
	lappend map @s $script
	proc $name {} [string map $map {
	    return [uplevel 1 {Measure {@n} {apply {{} {@s} ::kinetcl::stance::dsl}}}]
	}]
	return
    }

    # # ## ### ##### ######## ############# #####################
    ## Instance state
    ## - Reference to joints tracker, for removal of bindings.
    ## - stance status flags, per user and stance (user -> stance -> active y/n)
    ## - stance definitions
    ## - Per user cached measurements.

    variable myjoints mystatus mydef mymeasure

    # # ## ### ##### ######## ############# #####################
    ## Events from the joints tracker, entry to our stance checking internals.

    method UserCreate {__event __joints details} {
	dict with details {} ; # ==> user
	#puts "X($__event $__joints <$details>)"

	# Initialize the user's status for all the known stances.

	foreach stance [dict keys $mydef] {
	    dict set mystatus $user $stance off
	}
	return
    }

    method UserMove {__event __joints details} {
	dict with details {} ; # ==> user

	#puts "X($__event $__joints <$details>)"

	if {[catch {
	    set skeleton [$myjoints get-skeleton $user]
	}]} return

	# Import supporting variables from the DSL namespace.
	namespace upvar ::kinetcl::stance::dsl \
	    theskeleton theskeleton \
	    themeasure  themeasure

	# Save the current user's data for use by the DSL.
	set theskeleton $skeleton
	set themeasure $mymeasure

	# Check and update the status of all known stances against the
	# current user, and generate the proper the events for all
	# stances which changed their status.

	foreach stance [dict keys $mydef] {
	    set active [my StanceActive $stance]
	    my StanceStatus $user $stance $active
	    # Do not use the command below. That invokes a known bug
	    # of the BC machinery (with nested 'continue' etc., which
	    # the method can behave as at).
	    #my StanceStatus $user $stance [my StanceActive $stance]
	}

	# Save the cache of measures back, as it may have been extended.
	set mymeasure $themeasure

	# Remove the transient information from the DSL.
	set themeasure {}
	set theskeleton {}
	return
    }

    method UserDestroy {__event __joints details} {
	dict with details {} ; # ==> user
	#puts "X($__event $__joints <$details>)"

	# Drop the stati of all stances status for the user, possibly
	# sending out the proper deactivation events.

	foreach stance [dict keys $mydef] {
	    my StanceStatus $user $stance off
	    dict unset mystatus $user $stance
	}
	return
    }

    # # ## ### ##### ######## ############# #####################
    ## Stance checking, and management of the various internals.

    method StanceActive {stance} {
	# Run the definition script. The acessor commands have direct
	# access to the namespace...

	#puts S/A<$stance>_________________________________________________

	set ::errorInfo {}
	set active *

	set fail [catch {
	    set active [{*}[dict get $mydef $stance]]
	} msg]

	#puts S/A<$active><$stance><$fail>($::errorInfo)
	#puts S/A_________________________________________________

	# Missing joint information causes a special error which we
	# treat as non-error and not changing the stance status at
	# all. Any other errors we re-throw, considering them as
	# something the higher layers (like the user) should see.

	if {$fail == -5} {
	    return -code continue ; # skip stance (loop in UserMove).
	} elseif {$fail} {
	    return -code $fail $msg
	} else {
	    return $active
	}
    }

    method StanceStatus {user stance active} {
	# Translate from the current status of a stance for a user to
	# stance changes for that user, by comparing to the previous
	# status. Further update the internals to be ready for the next
	# comparison.

	set details [dict create user $user stance $stance]
	set current [dict get $mystatus $user $stance]

	#puts S/S|$user|$stance|$active<--$current|

	if {$active && !$current} {
	    my generate stance-enter $details
	} elseif {!$active && $current} {
	    my generate stance-exit  $details
	}

	dict set mystatus $user $stance $active
	return
    }

    # # ## ### ##### ######## ############# #####################
}

# # ## ### ##### ######## ############# #####################
## DSL support namespace

namespace eval ::kinetcl::stance::dsl {}

# # ## ### ##### ######## ############# #####################
## DSL. Compute 3D distance between any two named joints or the length
##      of one named segment.

proc ::kinetcl::stance::dsl::distance {args} {
    MAP $args a b
    set d [Distance $a $b]
    return $d
}

# # ## ### ##### ######## ############# #####################
## DSL. Public joint location accessors.

proc ::kinetcl::stance::dsl::head            {} { Joint head            }
proc ::kinetcl::stance::dsl::neck            {} { Joint neck            }
proc ::kinetcl::stance::dsl::torso           {} { Joint torso           }
proc ::kinetcl::stance::dsl::waist           {} { Joint waist           }
proc ::kinetcl::stance::dsl::left-collar     {} { Joint left-collar     }
proc ::kinetcl::stance::dsl::left-shoulder   {} { Joint left-shoulder   }
proc ::kinetcl::stance::dsl::left-elbow      {} { Joint left-elbow      }
proc ::kinetcl::stance::dsl::left-wrist      {} { Joint left-wrist      }
proc ::kinetcl::stance::dsl::left-hand       {} { Joint left-hand       }
proc ::kinetcl::stance::dsl::left-fingertip  {} { Joint left-fingertip  }
proc ::kinetcl::stance::dsl::left-hip        {} { Joint left-hip        }
proc ::kinetcl::stance::dsl::left-knee       {} { Joint left-knee       }
proc ::kinetcl::stance::dsl::left-ankle      {} { Joint left-ankle      }
proc ::kinetcl::stance::dsl::left-foot       {} { Joint left-foot       }
proc ::kinetcl::stance::dsl::right-collar    {} { Joint right-collar    }
proc ::kinetcl::stance::dsl::right-shoulder  {} { Joint right-shoulder  }
proc ::kinetcl::stance::dsl::right-elbow     {} { Joint right-elbow     }
proc ::kinetcl::stance::dsl::right-wrist     {} { Joint right-wrist     }
proc ::kinetcl::stance::dsl::right-hand      {} { Joint right-hand      }
proc ::kinetcl::stance::dsl::right-fingertip {} { Joint right-fingertip }
proc ::kinetcl::stance::dsl::right-hip       {} { Joint right-hip       }
proc ::kinetcl::stance::dsl::right-knee      {} { Joint right-knee      }
proc ::kinetcl::stance::dsl::right-ankle     {} { Joint right-ankle     }
proc ::kinetcl::stance::dsl::right-foot      {} { Joint right-foot      }

# # ## ### ##### ######## ############# #####################
## DSL. Test for various orientations (vertical, horizontal (to the
## side, and depth)) for segments or pairs of arbitrary joints.
#
## The test is done by comparing the full 3D distance against the
## axis-aligned distance in the chosen direction. The segment aligns
## with the direction if most of the 3d distance is in the chosen
## direction.

# Undirected alignment
proc ::kinetcl::stance::dsl::horizontal_side  {args} { OrientAxis horizontal_side  0 $args }
proc ::kinetcl::stance::dsl::vertical         {args} { OrientAxis vertical         1 $args }
proc ::kinetcl::stance::dsl::horizontal_depth {args} { OrientAxis horizontal_depth 2 $args }

# Directed alignment
proc ::kinetcl::stance::dsl::horizontal_right    {args} { OrientAxisD horizontal_right    > 0 $args }
proc ::kinetcl::stance::dsl::horizontal_left     {args} { OrientAxisD horizontal_left     < 0 $args }
proc ::kinetcl::stance::dsl::vertical_up         {args} { OrientAxisD vertical_up         > 1 $args }
proc ::kinetcl::stance::dsl::vertical_down       {args} { OrientAxisD vertical_down       < 1 $args }
proc ::kinetcl::stance::dsl::horizontal_backward {args} { OrientAxisD horizontal_backward > 2 $args }
proc ::kinetcl::stance::dsl::horizontal_forward  {args} { OrientAxisD horizontal_forward  < 2 $args }

# # ## ### ##### ######## ############# #####################
## Axis-aligned spatial relationships between joints and for segments.

proc ::kinetcl::stance::dsl::right  {args} { CompareAxis right  0 > $args } ;# positive x is right
proc ::kinetcl::stance::dsl::left   {args} { CompareAxis left   0 < $args } ;# negative x is left
proc ::kinetcl::stance::dsl::above  {args} { CompareAxis above  1 > $args } ;# positive y is up
proc ::kinetcl::stance::dsl::below  {args} { CompareAxis below  1 < $args } ;# negative y is down
proc ::kinetcl::stance::dsl::before {args} { CompareAxis before 2 < $args } ;# negative z is near
proc ::kinetcl::stance::dsl::behind {args} { CompareAxis behind 2 > $args } ;# positive z is far

# # ## ### ##### ######## ############# #####################
## DSL. Determine axis aligned distances.

proc ::kinetcl::stance::dsl::distance_side   {args} { DistanceAxis side   0 $args }
proc ::kinetcl::stance::dsl::distance_height {args} { DistanceAxis height 1 $args }
proc ::kinetcl::stance::dsl::distance_depth  {args} { DistanceAxis depth  2 $args }

# # ## ### ##### ######## ############# #####################
## DSL. Unit conversions. Base unit is [mm].

proc ::kinetcl::stance::dsl::mm   {x} { return $x }
proc ::kinetcl::stance::dsl::cm   {x} { * 10   $x }
proc ::kinetcl::stance::dsl::inch {x} { * 25.4 $x }

# # ## ### ##### ######## ############# #####################
## DSL. Internal. Core command handling measures (cached 3D distances).

proc ::kinetcl::stance::dsl::Measure {name cmd} {
    # The object scope with the data is 2 levels up
    # - Out of this procedure
    # - And out through the lambda holding the whole definition.
    variable themeasure

    # Check cache first.
    if {[dict exists $themeasure $name]} {
	return [dict get $themeasure $name]
    }

    # Not cached yet, compute it, then cache and return it.
    # Problems (missing joint information) abort this before the
    # caching happens, causing another attempt the next time
    # around.

    set value [{*}$cmd]
    dict set themeasure $name $value
    return $value
}

# # ## ### ##### ######## ############# #####################
## DSL. Internal. Undirected axis-aligned orientations.

proc ::kinetcl::stance::dsl::OrientAxis {label axis words} {
    variable dirthreshold

    DEBUG {[info level 0]}

    MAP $words a b

    set av [lindex $a $axis]
    set bv [lindex $b $axis]

    set d  [Distance $a $b]
    set da [expr {abs($av - $bv)}]
    set dt [expr {$dirthreshold * $d}]
    set ok [expr {$da >= $dt}]

    DEBUG {[info level 0] D [F $av] -- [F $bv]}
    DEBUG {[info level 0] A [>= $da $dt] : [F $dt] -- [F $da] -- [F $d]}
    DEBUG {[info level 0] R: $ok}

    return $ok
}

proc ::kinetcl::stance::dsl::OrientAxisD {label rel axis words} {
    variable dirthreshold

    DEBUG {[info level 0]}

    MAP $words a b

    set av [lindex $a $axis]
    set bv [lindex $b $axis]

    set d  [Distance $a $b]
    set da [expr {abs($av - $bv)}]
    set dt [expr {$dirthreshold * $d}]

    set ok [expr {($da >= $dt) && [$rel $av $bv]}]

    lassign $a ax ay az
    lassign $b bx by bz
    DEBUG {[info level 0] dx [F [expr {$bx - $ax}]] dy [F [expr {$by - $ay}]] dz [F [expr {$bz - $az}]]}

    DEBUG {[info level 0] C [$rel $av $bv] : [F $av] $rel [F $bv]}
    DEBUG {[info level 0] A [>= $da $dt] : [F $dt] -- [F $da] -- [F $d]}
    DEBUG {[info level 0] R : $ok}

    return $ok
}

# # ## ### ##### ######## ############# #####################
## DSL. Internal. Core for axis-aligned spatial relation ships.

proc ::kinetcl::stance::dsl::CompareAxis {label axis rel words} {
    DEBUG {[info level 0]}

    MAP $words a b

    set av [lindex $a $axis]
    set bv [lindex $b $axis]
    set ok [$rel $av $bv]

    DEBUG {[info level 0]: $ok}
    return $ok
}

# # ## ### ##### ######## ############# #####################
## DSL. Internal. Axis aligned distances/lengths.

proc ::kinetcl::stance::dsl::DistanceAxis {label axis words} {
    DEBUG {[info level 0]}

    MAP $words a b
    set av [lindex $a $axis]
    set bv [lindex $b $axis]
    set dv [expr {$bv - $av}]

    DEBUG {[info level 0]: $delta}
    return $delta
}

# # ## ### ##### ######## ############# #####################
## DSL. Internal. Euclidean distance between two 3D points.

proc ::kinetcl::stance::dsl::Distance {a b} {
    # a,b = 3d coordinates
    lassign $a ax ay az
    lassign $b bx by bz
    return [hypot \
		[hypot \
		     [- $bx $ax] \
		     [- $by $ay]] \
		[- $bz $az]]
}

# # ## ### ##### ######## ############# #####################
## DSL. Internal. Core accessor for joint locations.

proc ::kinetcl::stance::dsl::Joint {name} {
    DEBUG {[info level 0]}

    variable theskeleton
    if {![dict exists $theskeleton $name]} {
	DEBUG {[info level 0]: UNDEFINED}
	return -code -5
    }

    set location [dict get $theskeleton $name]

    DEBUG {[info level 0]: ([join [FL $location] { | }])}
    return $location
}

# # ## ### ##### ######## ############# #####################
## DSL. Internal. Argument processing. Segment/Joint translation.
#
## Accepts any two joint names, or a single segment name (which is
## translated into the two connected joints). Further translates the
## joints to the associated 3D coordinates, via the core joint
## accessor.

proc ::kinetcl::stance::dsl::MAP {words av bv} {
    DEBUG {[info level 0]}

    upvar 1 $av a $bv b
    if {[llength $words] == 2} {
	lassign $words aname bname
    } elseif {[llength $words] == 1} {
	variable segmentmap
	lassign [dict get $segmentmap [lindex $words 0]] aname bname
    } else {
	return -code error "wrong\#args: expected segment|jointa jointb"
    }

    set a [Joint $aname]
    set b [Joint $bname]

    DEBUG {[lrange [info level 0] 0 1] /return}
    return
}

# # ## ### ##### ######## ############# #####################
## DSL. Internal. Debug helper commands.

if {1} {
    proc ::kinetcl::stance::dsl::DEBUG {args} {}
} else {
    proc ::kinetcl::stance::dsl::DEBUG {msg} {
	puts [uplevel 1 [list subst $msg]]
	return
    }
}

proc ::kinetcl::stance::dsl::F {x} {
    format %7.2f $x
}

proc ::kinetcl::stance::dsl::FL {list} {
    set res {}
    foreach x $list {
	lappend res [format %7.2f $x]
    }
    return $res
}

# # ## ### ##### ######## ############# #####################
## Global common information

namespace eval ::kinetcl::stance::dsl {
    ## Mapping from named segments to the connected joints.  Hm
    ## ... Joints class ? ...

    variable segmentmap {
	left-lower-arm {left-hand left-elbow}
	left-upper-arm {left-elbow left-shoulder}
	left-lower-leg {left-foot left-knee}
	left-upper-leg {left-knee left-hip}

	right-lower-arm {right-hand right-elbow}
	right-upper-arm {right-elbow right-shoulder}
	right-lower-leg {right-foot right-knee}
	right-upper-leg {right-knee right-hip}
    }

    # Directional threshold.
    variable dirthreshold 0.7 ; # 70%

    # Transient data, a user skeleton, aka joint locations.
    variable theskeleton {}

    # Transient data, cache of user measurements.
    variable themeasure {}

    # Make Tcl's math functions and operator available.
    namespace path [linsert [namespace path] end ::tcl::mathfunc ::tcl::mathop]
    # # ## ### ##### ######## ############# #####################
}


# # ## ### ##### ######## ############# #####################
package provide kinetcl::stance 0
return
