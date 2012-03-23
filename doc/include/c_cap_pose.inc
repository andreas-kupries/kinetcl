
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Pose Detection}]

Should an instance support pose detection the following methods become
available.

This support can checked by invoking the inherited method
[method is-capable-of] for the capability name
[const user-pose-detection].

[list_begin definitions]

[comment ===============================================================]
[call [arg instanceCmd] [method poses]]

This method returns a list containing the names of the supported user
poses.

[comment ===============================================================]
[call [arg instanceCmd] [method is-supported] [arg pose]]

This method tests if the named user pose is supported by the instance.

[para] The result is a boolean value, [const true] if the pose is
supported, and [const false] else.

[comment ===============================================================]
[call [arg instanceCmd] [method start-detection] [arg user] [arg pose]]

This method activates the detection of the named [arg pose] for the
specified [arg user].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method stop-detection] [arg user] [arg pose]]

This method deactivates the detection of the named [arg pose] for the
specified [arg user].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method stop-all-detection] [arg user]]

This method deactivates the detection of any poses for the specified
[arg user].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method status] [arg user] [arg pose]]

This method queries the status of the detection of the named [arg pose]
for the specified [arg user].

[para] The result of the method is 3-element string containing, in the named order

[list_begin enumerated]

[enum] The state of the user with respect to the pose,
one of [const in], [const out], or [const undefined]

[enum] The status of the detection progress.
[para] The possible stati are
[list_begin enumerated]
[enum][const ok]
[enum][const no-user]
[enum][const top-fov]
[enum][const side-fov]
[enum][const error]
[enum][const no-tracking]
[list_end]

[enum] A timestamp telling us when the user entered the pose, if it is
in the pose. If the user is out of the pose [const 0] is returned
here.

[list_end]

[comment ===============================================================]
[vset NAME pose-enter]
[vset NUM 4]
[vset EARGS pose]
[vset DESC {a user entering a pose.}]
[include callback.inc]

[comment ===============================================================]
[vset NAME pose-exit]
[vset NUM 4]
[vset EARGS pose]
[vset DESC {a user exiting a pose.}]
[include callback.inc]

[comment ===============================================================]
[vset NAME pose-progress]
[vset NUM 5]
[vset EARGS posep]
[vset DESC {the system's progress in the detection of a pose for a user.}]
[include callback.inc]

[list_end]
