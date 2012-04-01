## -*- tcl -*-
# # ## ### ##### ######## ############# #####################

## This file defines a TclOO class using a 'user' generator to track
## all users and their skeleton joints, to generate events on changes.
## This encapsulates and hides the basic polling done on a user
## generator to get the skeleton information.

# # ## ### ##### ######## ############# #####################

package require TclOO
package require oo::util ; # tcllib, mymethod.
package require uevent

# # ## ### ##### ######## ############# #####################

oo::class create ::kinetcl::joints {
    superclass ::kinetcl::eventbase

    # # ## ### ##### ######## ############# #####################
    constructor {{user {}}} {
	next
	my Register {
	    user-create user-move user-destroy
	    joint-create joint-mode joint-destroy
	}

	if {$user eq {}} {
	    # Created in the instance namespace this object will be
	    # auto-cleaned on destruction.
	    set user [kinetcl user create MYUSER]
	} else {
	    kinetcl validate $user
	}

	set myuser      $user
	set mydata      {}
	set mythreshold 0.5
	set mytoken     {}
	return
    }

    destructor {
	my unbound
	return
    }

    method threshold {{value {}}} {
	if {[llength [info level 0] == 3]} {
	    if {![string is double -strict $value] ||
		($value < 0) ||
		($value > 1)} {
		return -code error -errorcode {KINETCL VALUE DOUBLE CONFIDENCE} \
		    "Expected double in range \[0..1\], got \"$value\""
	    }
	    set mythreshold $value
	}
	return $mythreshold
    }

    method get-generator {} {
	return $myuser
    }

    method get-joint {user joint} {
	# Return skeleton information from the local cache instead of
	# going into the associated user instance.
	return [dict get $mydata $user $joint]
    }

    method get-skeleton {user} {
	# Return skeleton information from the local cache instead of
	# going into the associated user instance.
	return [dict get $mydata $user]
    }

    method unknown {args} {
	# Anything unknown gets delegated to the user instance
	# providing us with the raw user and joint data.
	return [$myuser {*}$args]
    }

    # # ## ### ##### ######## ############# #####################
    ## Track if this instance is observed or not, and use that
    ## information to start/stop the tracking of users and their
    ## skeletons.

    method bound {} {
	# If we are observed we have to track users
	set mytoken {}
	lappend mytoken [$myuser bind newdata              [mymethod Track]]
	lappend mytoken [$myuser bind user-new             [mymethod New]]
	lappend mytoken [$myuser bind user-exit            [mymethod Exit]]
	lappend mytoken [$myuser bind user-lost            [mymethod Lost]]
	lappend mytoken [$myuser bind calibration-complete [mymethod Calibration]]
	return
    }

    method unbound {} {
	# If we are not observed anymore we can stop tracking users.
	foreach t $mytoken { $myuser unbind $token }
	set mytoken {}
	return
    }

    # # ## ### ##### ######## ############# #####################

    method New {event obj details} {
	dict with details {} ; # --> user
	# assert (event == "user-new")
	# assert ($obj == $myuser)

	$myuser request-calibration $user 0
	return
    }

    method Exit {event obj details} {
	dict with details {} ; # --> user
	# assert (event == "user-exit")
	# assert ($obj == $myuser)

	my DropUser $user
	return
    }

    method Lost {event obj details} {
	dict with details {} ; # --> user
	# assert (event == "user-lost")
	# assert ($obj == $myuser)

	my DropUser $user
	return
    }

    method Calibration {event obj details} {
	dict with details {} ; # --> user status
	# assert (event == "calibration-complete")
	# assert ($obj == $myuser)
	if {$status eq "ok"} {
	    # The specified user is now calibrated, and we are
	    # therefore able to track its skeleton/joints.
	    $myuser start-tracking $user
	} else {
	    # Retry to aquire the necessary tracking data.
	    $myuser request-calibration $user 0
	}
	return
    }

    method Track {event obj details} {
	#dict with details {} ; # --> empty
	# assert (event == "newdata")
	# assert ($obj == $myuser)

	set theusers [$myuser users]

	# Stage 1, check which users dropped out.
	foreach user [dict keys $mydata] {
	    if {$user in $theusers} continue
	    my DropUser $user
	}

	# Stage 2, check which users dropped in, or moved.
	# Ignore all users not yet tracked.
	foreach user $theusers {
	    if {![$myuser is-tracking $user]} return

	    set udetails [dict create user $user]

	    if {![dict exists $mydata $user]} {
		dict set mydata $user {}
		my generate user-create $udetails
	    }

	    set changed 0

	    dict for {joint data} [$myuser get-skeleton $user] {
		lassign $data position orientation
		lassign $position confidence location

		if {$confidence < $mythreshold} {
		    if {[dict exists $mydata $user $joint]} {
			# The skeleton tracker lost confidence in the joint's location.
			dict unset mydata $user $joint
			set details [dict create user $user joint $joint]
			my generate joint-destroy $details
			set changed 1
		    }
		} else {
		    set details [dict create user $user joint $joint position $location]
		    if {![dict exists $mydata $user $joint]} {
			# system just became confident in the joint location
			dict set mydata $user $joint $location
			my generate joint-create $details
			set changed 1
		    } else {
			# check for location change, generate event only on true change.
			lassign [dict get $mydata $user $joint] oldx oldy oldz
			lassign $location                       newx newy newz

			if {($oldx != $newx) ||
			    ($oldy != $newy) ||
			    ($oldz != $newz)} {
			    dict set mydata $user $joint $location
			    my generate joint-move $details
			    # different tag ? ((self+user)+joint)
			    set changed 1
			}
		    }
		}
	    }

	    if {$changed} {
		my generate user-move $udetails
	    }
	}
	return
    }

    method DropUser {user} {
	if {![dict exists $mydata $user]} return
	foreach joint [dict keys [dict get $mydata $user]] {
	    my generate joint-destroy [dict create user $user joint $joint]
	}
	my generate user-destroy [dict create user $user]
	dict unset mydata $user
	return
    }

    # # ## ### ##### ######## ############# #####################

    variable myuser mydata mythreshold

    # # ## ### ##### ######## ############# #####################
}

# # ## ### ##### ######## ############# #####################
package provide kinetcl::joints 0
return
