
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Skeleton/Joint Tracking}]

Should an instance support skeleton and joint tracking the following
methods become available.

This support can checked by invoking the inherited method
[method is-capable-of] for the capability name
[const user-skeleton].

[list_begin definitions]
[comment ===============================================================]
[call [arg instanceCmd] [method need-pose]]

This method tests if the skeleton tracking requires the user to enter
a pose for calibration.

[para] The result is a boolean value, [const true] if entering a pose
is required, and [const false] else.

[emph NOTE]: XXX. The C API to query the name of the required pose
looks to be borken, or underspecified. Research required.

[comment ===============================================================]
[call [arg instanceCmd] [method is-profile-available] [arg profile]]

This method tests if the skeleton tracking supports the named
[arg profile].

[para] The result is a boolean value, [const true] if the profile is
supported, and [const false] else.

[para] The accepted profile names are
[list_begin enumerated]
[enum][const none]
[enum][const all]
[enum][const upper]
[enum][const lower]
[enum][const heads-hands]
[list_end]

[comment ===============================================================]
[call [arg instanceCmd] [method set-profile] [arg profile]]

This method activates the named [arg profile]. This will result in
joints getting activated or deactivated, as per the profile.

[para] The accepted profile names are described above, at
[method is-profile-available].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method set-smoothing] [arg factor]]

This method sets the skeleton smoothing [arg factor], a floating point
value.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method start-tracking] [arg id]]

This method activates the tracking of the skeleton for the user
specified by the [arg id].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method stop-tracking] [arg id]]

This method stops tracking of the skeleton for the user
specified by the [arg id].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method reset-tracking] [arg id]]

This method discards the calibration of the skeleton for the user
specified by the [arg id].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method is-tracking] [arg id]]

This method tests if the skeleton for the user [arg id] is currently
tracked.

[para] The result is a boolean value, [const true] if tracking is
active, and [const false] else.

[comment ===============================================================]
[call [arg instanceCmd] [method is-calibrated] [arg id]]

This method tests if the skeleton for the user [arg id] is calibrated.

[para] The result is a boolean value, [const true] if the skeleton is
calbrated, and [const false] else.

[comment ===============================================================]
[call [arg instanceCmd] [method is-calibrating] [arg id]]

This method tests if calibration of the skeleton for the user [arg id]
is currently in progress.

[para] The result is a boolean value, [const true] if calibration is
in progress, and [const false] else.

[comment ===============================================================]
[call [arg instanceCmd] [method request-calibration] [arg id] [arg force]]

This method requests calibration of the skeleton for the user
specified by the [arg id].

[para] The result of the method is an empty string.

[para] If the boolean flag [arg force] is set any previous calibration
data is discarded.

[comment ===============================================================]
[call [arg instanceCmd] [method abort-calibration] [arg id]]

This method stops a calibration in progress, for the user specified by
the [arg id].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method save-calibration-file] [arg id] [arg path]]

This method saves the calibration data for the skeleton of the user
specified by the [arg id] into the file [arg path]. The format of the
calibration data is not documented.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method load-calibration-file] [arg id] [arg path]]

This method loads the calibration data for the skeleton of the user
specified by the [arg id] from the file [arg path]. The format of the
calibration data is not documented.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method save-calibration] [arg id] [arg slot]]

This method saves the calibration data for the skeleton of the user
specified by the [arg id] into the in-memory storage identified by the
[arg slot] number.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method load-calibration-slot] [arg id] [arg slot]]

This method loads the calibration data for the skeleton of the user
specified by the [arg id] from the in-memory storage identified by the
[arg slot] number.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method clear-calibration-slot] [arg slot]]

This method clears the in-memory calibration data storage identified
by the [arg slot] number.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method is-calibration-slot] [arg slot]]

This method tests if the in-memory storage identified by the
[arg slot] number contains skeleton calibration data.

[para] The result is a boolean value, [const true] if the slot is
occupied, and [const false] else.

[comment ===============================================================]
[call [arg instanceCmd] [method is-joint-available] [arg joint]]

This method tests if the skeleton tracking supports the named
[arg joint].

[para] The result is a boolean value, [const true] if the joint is
supported, and [const false] else.

[para] The accepted joint names are
[list_begin enumerated]
[enum][const head]
[enum][const neck]
[enum][const torso]
[enum][const waist]
[enum][const left-collar]
[enum][const left-shoulder]
[enum][const left-elbow]
[enum][const left-wrist]
[enum][const left-hand]
[enum][const left-fingertip]
[enum][const right-collar]
[enum][const right-shoulder]
[enum][const right-elbow]
[enum][const right-wrist]
[enum][const right-hand]
[enum][const right-fingertip]
[enum][const left-hip]
[enum][const left-knee]
[enum][const left-ankle]
[enum][const left-foot]
[enum][const right-hip]
[enum][const right-knee]
[enum][const right-ankle]
[enum][const right-foot]
[list_end]

[comment ===============================================================]
[call [arg instanceCmd] [method is-joint-active] [arg joint]]

This method tests if the the named [arg joint] is actively tracked.

[para] The result is a boolean value, [const true] if the joint is
active, and [const false] else.

[para] The accepted joint names are described above, at
[method is-joint-available].

[comment ===============================================================]
[call [arg instanceCmd] [method set-joint-active] [arg joint] [arg active]]

This method (de)activates the named [arg joint].

[para] The accepted joint names are described above, at
[method is-joint-available].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method active-joints]]

This method returns a list containig the names of all currently active
joints.

[para] The possible joint names are described above, at
[method is-joint-available].

[comment ===============================================================]
[call [arg instanceCmd] [method get-joint] [arg user] [arg joint]]

This method retrieves position and orientation data for the user
specified by [arg id] and the named [arg joint].

[para] The accepted joint names are described above, at
[method is-joint-available].

[para] The result of the command is a 2-element list containing, in
the order specified:
[list_begin definitions]
[def position] A 2-element list containing, in the order specified:
[list_begin definitions]
[def confidence] A floating point value representing the system's
confidence in the position information.
[def coordinates] A 3-element list of floating point values
representing the x-, y-, and z-position of the joint.
[list_end]
[def orientation] A 2-element list containing, in the order specified:
[list_begin definitions]
[def confidence] A floating point value representing the system's
confidence in the orientation information.
[def rotation] A 9-element list of floating point values
representating the rotation matrix for the joint.
[list_end]
[list_end]

[comment ===============================================================]
[call [arg instanceCmd] [method get-skeleton] [arg user]]

This method retrieves the position and orientation data for all joints
of the user specified by [arg id]. In other words, the whole skeleton,
as available and active.

[para] The result of the method is a dictionary mapping joint names to
position and orientation, given in the format returned by method
[method get-joint].

[para] Joints which are either not available or not actively tracked
will not be found in the dictionary.

[list_end]

[include cevents.inc]

[comment ===============================================================]
[vset NAME joint]
[vset EARGS null]
[vset DESC {joint changes, i.e. the (de)activation of specific joints}]
[include callback.inc]

[comment ===============================================================]
[vset NAME calibration-start]
[vset EARGS user]
[vset DESC {the start of skeleton calibration for a user}]
[include callback.inc]

[comment ===============================================================]
[vset NAME calibration-complete]
[vset EARGS skel]
[vset DESC {the completion of skeleton calibration for a user}]
[include callback.inc]

[comment ===============================================================]
[vset NAME calibration-progress]
[vset EARGS skel]
[vset DESC {the system's progress in the calibration of the skeleton for a user}]
[include callback.inc]
