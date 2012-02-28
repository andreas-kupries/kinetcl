
This sections documents the class [cmd ::kinetcl::user], the concrete
class for all OpenNI user generator nodes.

[para] This class inherits from [cmd ::kinetcl::generator] and its
superclasses. See section [sectref {Generator}].

[para] A user generator identifies and tracks users within the field
of view of the sensor.

[para] They may have the following capabilities:
[list_begin enumerated]
[enum] [sectref {Instance Pose Detection API}]
[enum] [sectref {Instance Hand Touching FOV Edge API}]
[enum] [sectref {Instance Skeleton/Joint API}]
[list_end]

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
id, as a 3-element list, i.e. vector, of floating point coordinates.
The coordinates are specified in the order of X, Y, and Z.

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
