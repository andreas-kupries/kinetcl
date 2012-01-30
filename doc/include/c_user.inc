
This sections documents the class [cmd ::kinetcl::user], the concrete class
for all OpenNI user generator nodes.

[para] This class inherits from [cmd ::kinetcl::generator] and its
superclasses.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd ::kinetcl::user]]

This command creates a new user generator instance and returns the
fully qualified name of the instance command. The API provided by that
command, i.e. the set of available methods and their semantics is
described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg userInstanceCmd] [method destroy]]

This method destroys the user generator instance and releases all
associated resources, including the instance command. Note that
resources used by multiple instances are released only when the last
instance using them is destroyed.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method count]]

This method returns the number of users currently tracked by the
user generator instance.

[comment ===============================================================]
[call [arg userInstanceCmd] [method users]]

This method returns a list containing the ids of the users currently
tracked by the user generator instance.

[comment ===============================================================]
[call [arg userInstanceCmd] [method centerof] [arg id]]

This method returns the center location for the user specified by its
id, as a 3-element list, i.e. vector, of integer coordinates. The
coordinates are specified in the order of X, Y, and Z.

[para] The method will throw an error if the user id is not valid.

[comment ===============================================================]
[call [arg userInstanceCmd] [method pixelsof] [arg id]]

This method is [emph {not implemented}]. When done it will return a
[package crimp] image of type [const <unknown>] where all pixels
representing the user are set to the user's id, and everything else
set to [const 0].

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-enter] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-enter]]

These methods define and remove a callback responding to re-entry
events, i.e. a user re-entering the scene after exiting it.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with three arguments added to it, the instance
command, the word "enter", and the (numerical) id of the user
re-entering, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-exit] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-exit]]

These methods define and remove a callback responding to exit events,
i.e. a user exiting the scene.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with three arguments added to it, the instance
command, the word "exit", and the (numerical) id of the user exiting,
in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-new] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-new]]

These methods define and remove a callback responding to "new user"
events, i.e. when a new user is identified.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with three arguments added to it, the instance
command, the word "new", and the (numerical) id of the newly
identified user, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-lost] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-lost]]

These methods define and remove a callback responding to "lost user"
events, i.e. when a user is no longer identified.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with three arguments added to it, the instance
command, the word "lost", and the (numerical) id of the lost user, in
this order.

[para] The result of the methods is an empty string.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance Pose Detection API}]

Should the user generator instance support the pose detection API the
following methods become available. This support can checked by
invoking the inherited method [method isCapableOf] for the capability
name [const user-pose-detection].

[list_begin definitions]

[comment ===============================================================]
[call [arg userInstanceCmd] [method poses]]

This method returns a list containing the names of the supported user
poses.

[comment ===============================================================]
[call [arg userInstanceCmd] [method isSupported] [arg pose]]

This method tests if the named user pose is supported by the instance.

[para] The result is a boolean value, [const true] if the pose is
supported, and [const false] else.

[comment ===============================================================]
[call [arg userInstanceCmd] [method start-detection] [arg user] [arg pose]]

This method activates the detection of the named [arg pose] for the
specified [arg user].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method stop-detection] [arg user] [arg pose]]

This method deactivates the detection of the named [arg pose] for the
specified [arg user].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method stop-all-detection] [arg user]]

This method deactivates the detection of any poses for the specified
[arg user].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method status] [arg user] [arg pose]]

This method queries the status of the detection of the named [arg
pose] for the specified [arg user].

[para] The result of the method is 3-element string containing, in the named order
[list_begin]

[enum] The state of the user with respect to the pose,
one of [const in], [const out], or [const unkown]

[enum] The status of the detection progress.

[enum] A timestamp telling us when the user entered the pose, if it is
in the pose. If the user is out of the pose [const 0] is returned
here.

[list_end]

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-poseEnter] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-poseEnter]]

These methods define and remove a callback responding to pose entry
events, i.e. a user entering a pose.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with four arguments added to it, the instance command,
the word "poseEnter", the name of the pose entered and the (numerical)
id of the user entering it, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-poseExit] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-poseExit]]

These methods define and remove a callback responding to pose exit
events, i.e. a user existing a pose.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with four arguments added to it, the instance command,
the word "poseExit", the name of pose, and the (numerical) id of the
user exiting it, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-poseProgress] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-poseProgress]]

These methods define and remove a callback responding to pose progress
events, i.e. the steps of the engine for detecting user poses.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with five arguments added to it, the instance command,
the word "poseProgress", the name of pose, the (numerical) id of the
user, and the status of the detection engine, in this order.

[para] The result of the methods is an empty string.

[list_end]
