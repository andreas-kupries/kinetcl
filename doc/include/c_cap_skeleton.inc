
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance Skeleton/Joint API}]

Should the user generator instance support the skeleton API the
following methods become available. This support can checked by
invoking the inherited method [method is-capable-of] for the
capability name [const user-skeleton].

[list_begin definitions]
[comment ===============================================================]
[call [cmd userInstanceCmd] [method need-pose]]

This method tests if the skeleton tracking requires the user to enter
a pose for calibration.

[para] The result is a boolean value, [const true] if entering a pose
is required, and [const false] else.

[emph NOTE]: XXX. The C API to query the name of the required pose
looks to be borken, or underspecified. Research required.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method is-profile-available] [arg profile]]

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
[call [cmd userInstanceCmd] [method set-profile] [arg profile]]

This method activates the named [arg profile]. This will result in
joints getting activated or deactivated, as per the profile.

[para] The accepted profile names are described above, at
[method is-profile-available].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method set-smoothing] [arg factor]]

This method sets the skeleton smoothing [arg factor], a floating point
value.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method start-tracking] [arg id]]

This method activates the tracking of the skeleton for the user
specified by the [arg id].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method stop-tracking] [arg id]]

This method stops tracking of the skeleton for the user
specified by the [arg id].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method reset-tracking] [arg id]]

This method discards the calibration of the skeleton for the user
specified by the [arg id].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method is-tracking] [arg id]]

This method tests if the skeleton for the user [arg id] is currently
tracked.

[para] The result is a boolean value, [const true] if tracking is
active, and [const false] else.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method is-calibrated] [arg id]]

This method tests if the skeleton for the user [arg id] is calibrated.

[para] The result is a boolean value, [const true] if the skeleton is
calbrated, and [const false] else.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method is-calibrating] [arg id]]

This method tests if calibration of the skeleton for the user [arg id]
is currently in progress.

[para] The result is a boolean value, [const true] if calibration is
in progress, and [const false] else.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method request-calibration] [arg id] [arg force]]

This method requests calibration of the skeleton for the user
specified by the [arg id].

[para] The result of the method is an empty string.

[para] If the boolean flag [arg force] is set any previous calibration
data is discarded.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method abort-calibration] [arg id]]

This method stops a calibration in progress, for the user specified by
the [arg id].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method save-calibration-file] [arg id] [arg path]]

This method saves the calibration data for the skeleton of the user
specified by the [arg id] into the file [arg path]. The format of the
calibration data is not documented.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method load-calibration-file] [arg id] [arg path]]

This method loads the calibration data for the skeleton of the user
specified by the [arg id] from the file [arg path]. The format of the
calibration data is not documented.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method save-calibration] [arg id] [arg slot]]

This method saves the calibration data for the skeleton of the user
specified by the [arg id] into the in-memory storage identified by the
[arg slot] number.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method load-calibration-slot] [arg id] [arg slot]]

This method loads the calibration data for the skeleton of the user
specified by the [arg id] from the in-memory storage identified by the
[arg slot] number.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method clear-calibration-slot] [arg slot]]

This method clears the in-memory calibration data storage identified
by the [arg slot] number.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method is-calibration-slot] [arg slot]]

This method tests if the in-memory storage identified by the
[arg slot] number contains skeleton calibration data.

[para] The result is a boolean value, [const true] if the slot is
occupied, and [const false] else.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method is-joint-available] [arg joint]]

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
[call [cmd userInstanceCmd] [method is-joint-active] [arg joint]]

This method tests if the the named [arg joint] is actively tracked.

[para] The result is a boolean value, [const true] if the joint is
active, and [const false] else.

[para] The accepted joint names are described above, at
[method is-joint-available].

[comment ===============================================================]
[call [cmd userInstanceCmd] [method set-joint-active] [arg joint] [arg active]]

This method (de)activates the named [arg joint].

[para] The accepted joint names are described above, at
[method is-joint-available].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd userInstanceCmd] [method active-joints]]

This method returns a list containig the names of all currently active
joints.

[para] The possible joint names are described above, at
[method is-joint-available].

[comment ===============================================================]
[call [cmd userInstanceCmd] [method get-joint] [arg user] [arg joint]]

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
[call [arg userInstanceCmd] [method set-callback-jointConfigChange] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-jointConfigChange]]

These methods define and remove a callback responding to joint
configration changes, i.e. when joints are (de)activated.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with two arguments added to it, the instance command,
and the word "jointConfigChange", in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-calibrationStart] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-calibrationStart]]

These methods define and remove a callback responding to the start of
a calibration.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with three arguments added to it, the instance
command, the word "calibrationStart", and the (numerical) id of the
user for whom calibration has started, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-calibrationComplete] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-calibrationComplete]]

These methods define and remove a callback responding to the
completion of calibrations.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with four arguments added to it, the instance command,
the word "calibrationComplete", the (numerical) id of the user for
whom calibration completed, and the completion status, in this order.

[para] The result of the methods is an empty string.

[para] The possible completion stati are
[list_begin enumerated]
[enum][const ok]
[enum][const no-user]
[enum][const arm]
[enum][const leg]
[enum][const head]
[enum][const torso]
[enum][const top-fov]
[enum][const side-fov]
[enum][const pose]
[enum][const manual-abort]
[enum][const manual-reset]
[enum][const timeout]
[list_end]

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-calibrationProgress] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-calibrationProgress]]

These methods define and remove a callback responding to calibration
progress events.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with four arguments added to it, the instance command,
the word "calibrationProgress", the (numerical) id of the user, and the
calibration progreess status, in this order.

[para] The result of the methods is an empty string.

[para] The possible progress stati are identical to the completion
stati described above.

[list_end]
