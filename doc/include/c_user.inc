
This sections documents the class [cmd ::kinetcl::user],
which provides instances of user generators,
derived from generators,
derived from production nodes.

[para] ... describe user generator ....

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
[call [method destroy]]

This method destroys the instance and releases all associated resources.
Note that resources used by multiple instances are released only when the
last instance using them is destroyed.

The result of the method is the empty string.

Afterward the instance command is deleted.

[comment ===============================================================]
[call [method count]]

This method returns the number of users currently tracked by the
user generator instance.

[comment ===============================================================]
[call [method users]]

This method returns a list containing the ids of the users currently
tracked by the user generator instance.

[comment ===============================================================]
[call [method centerof] [arg id]]

This method returns the center location for the user specified by its
id, as a 3-element list, i.e. vector, of integer coordinates. The
coordinates are specified in the order of X, Y, and Z.

[para] The method will throw an error if the user id is not valid.

[comment ===============================================================]
[call [method pixelsof] [arg id]]

This method is [emph {not implemented}]. When done it will return a
[package crimp] image of type [const <unknown>] where all pixels
representing the user are set to the user's id, and everything else
set to [const 0].

[comment ===============================================================]
[comment {
	API unification - single callback for all events?
	Single method to specify all callbacks, with sub-method
	to specify which event is (un)bound.
}]
[call [method onEnter]]
[call [method onEnter] [arg cmd] [arg arg]...]

This method removes (first syntax) or sets (second syntax) a command
prefix to be called when a user which left the scene re-enters it.

[para] The command prefix is invoked with the id of the re-entering
user as the last argument.

[comment ===============================================================]
[call [method onExit]]
[call [method onExit] [arg cmd] [arg arg]...]

This method removes (first syntax) or sets (second syntax) a command
prefix to be called when a user leaves the scene.

[para] The command prefix is invoked with the id of the leaving user
as the last argument.

[comment ===============================================================]
[call [method onNewOrLost]]
[call [method onNewOrLost] [arg cmd] [arg arg]...]

This method removes (first syntax) or sets (second syntax) a command
prefix to be called when a new user is detected in the scene, or an
existing user completely lost.

[para] The command prefix is invoked with two arguments, the event
happening ([const new] or [const lost]), and the id of the new/lost
user, in this order.

[list_end]
