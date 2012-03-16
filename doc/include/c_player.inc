
This sections documents the class [cmd {::kinetcl player}], the
concrete class for all OpenNI player nodes.

[para] This class inherits from [cmd {::kinetcl base}]. See section
[sectref {Base}].

[para] A player read a stream of sensor information from a file and
injects it into the system, faking the existence of a sensor.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl player}] [method new]]
[call [cmd {::kinetcl player}] [method create] [arg objname]]

This command creates a new player instance and returns the fully
qualified name of the instance command. The API provided by that
command, i.e. the set of available methods and their semantics is
described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg playerInstanceCmd] [method destroy]]

This method destroys the player instance and releases all associated
resources, including the instance command. Note that resources used
by multiple instances are released only when the last instance using
them is destroyed.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg playerInstanceCmd] [method speed] [arg speed]]

This method sets the speed of playback as a ratio of the time passed
in the recording. I.e. a speed of [const 1] implies playback at the
same frame/rate as recorded, whereas a speed < 1 causes slow-motion,
and a speed > 1 fast-forward.

[para] The result of the method is the empty string.

[call [arg playerInstanceCmd] [method speed]]

This method returns the speed of playback, as a ratio of the time
passed in the recording.

[para] The result of the method is a floating point number.

[comment ===============================================================]
[call [arg playerInstanceCmd] [method repeat] [arg bool]]

This method activates or deactivates repeating mode. If repeating is
activated ([arg bool] is [const true]) the player will automatically
rewind to the beginning of the recording when reaching the end, and
continue playing.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg playerInstanceCmd] [method eof]]

This method tests if the player has reached the end of the recording,
or not. Note that this is never [const true] when the player is in
repeating mode, however "eof" events are still triggered.

[para] The result of the method is boolean value, [const true] if the
player is at the end of the recording, and [const false] else.

[comment ===============================================================]
[call [arg playerInstanceCmd] [method format]]

This method returns the name of the format supported by the player instance.

[comment ===============================================================]
[call [arg playerInstanceCmd] [method next]]

This method causes the player to explicitly advance to the next frame.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-eof] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-eof]]

These methods define and remove a callback responding to "eof" events,
i.e. when the end of the recording was reached.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with three arguments added to it, the instance
command, and the word "eof", in this order.

[para] The result of the methods is an empty string.

[list_end]
