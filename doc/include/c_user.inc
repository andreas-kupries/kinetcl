
This sections documents the class [cmd {::kinetcl user}], the concrete
class for all OpenNI user generator nodes.

[para] This class inherits from [cmd {::kinetcl generator}] and its
superclasses. See section [sectref {Generator}].

[para] A user generator identifies and tracks users within the field
of view of the sensor.

[para] They may have the following capabilities:
[list_begin enumerated]
[enum] [sectref {Pose Detection}]
[enum] [sectref {Hand Touching FOV Edge}]
[enum] [sectref {Skeleton/Joint Tracking}]
[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl user}] [method new]]
[call [cmd {::kinetcl user}] [method create] [arg objname]]

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

This method returns a [package crimp] image of type [const grey16]
where all pixels representing the user are set to the user's id, and
everything else set to [const 0].

[comment ===============================================================]
[vset NAME user-enter]
[vset NUM 3]
[vset EARGS user]
[vset DESC {a user re-entering the scene.}]
[include callback.inc]

[comment ===============================================================]
[vset NAME user-exit]
[vset NUM 3]
[vset EARGS user]
[vset DESC {a user existing the scene.}]
[include callback.inc]

[comment ===============================================================]
[vset NAME user-new]
[vset NUM 3]
[vset EARGS user]
[vset DESC {the recognition of a new user.}]
[include callback.inc]

[comment ===============================================================]
[vset NAME user-lost]
[vset NUM 3]
[vset EARGS user]
[vset DESC {the loss of a user (after exiting the scene).}]
[include callback.inc]

[list_end]
