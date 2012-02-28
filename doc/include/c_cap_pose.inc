
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance Pose Detection API}]

Should a production node support the pose detection API the following
methods become available.

This support can checked by invoking the inherited method
[method is-capable-of] for the capability name
[const user-pose-detection].

[list_begin definitions]

[comment ===============================================================]
[call [cmd instanceCmd] [method poses]]

This method returns a list containing the names of the supported user
poses.

[comment ===============================================================]
[call [cmd instanceCmd] [method is-supported] [arg pose]]

This method tests if the named user pose is supported by the instance.

[para] The result is a boolean value, [const true] if the pose is
supported, and [const false] else.

[comment ===============================================================]
[call [cmd instanceCmd] [method start-detection] [arg user] [arg pose]]

This method activates the detection of the named [arg pose] for the
specified [arg user].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd instanceCmd] [method stop-detection] [arg user] [arg pose]]

This method deactivates the detection of the named [arg pose] for the
specified [arg user].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd instanceCmd] [method stop-all-detection] [arg user]]

This method deactivates the detection of any poses for the specified
[arg user].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [cmd instanceCmd] [method status] [arg user] [arg pose]]

This method queries the status of the detection of the named [arg pose]
for the specified [arg user].

[para] The result of the method is 3-element string containing, in the named order

[list_begin enumerated]

[enum] The state of the user with respect to the pose,
one of [const in], [const out], or [const unkown]

[enum] The status of the detection progress.

[enum] A timestamp telling us when the user entered the pose, if it is
in the pose. If the user is out of the pose [const 0] is returned
here.

[list_end]

[comment ===============================================================]
[call [cmd instanceCmd] [method set-callback-poseEnter] [arg cmd]...]
[call [cmd instanceCmd] [method unset-callback-poseEnter]]

These methods define and remove a callback responding to pose entry
events, i.e. a user entering a pose.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with four arguments added to it, the instance command,
the word "poseEnter", the name of the pose entered and the (numerical)
id of the user entering it, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [cmd instanceCmd] [method set-callback-poseExit] [arg cmd]...]
[call [cmd instanceCmd] [method unset-callback-poseExit]]

These methods define and remove a callback responding to pose exit
events, i.e. a user existing a pose.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with four arguments added to it, the instance command,
the word "poseExit", the name of pose, and the (numerical) id of the
user exiting it, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [cmd instanceCmd] [method set-callback-poseProgress] [arg cmd]...]
[call [cmd instanceCmd] [method unset-callback-poseProgress]]

These methods define and remove a callback responding to pose progress
events, i.e. the steps of the engine for detecting user poses.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with five arguments added to it, the instance command,
the word "poseProgress", the name of pose, the (numerical) id of the
user, and the status of the detection engine, in this order.

[para] The result of the methods is an empty string.

[list_end]
