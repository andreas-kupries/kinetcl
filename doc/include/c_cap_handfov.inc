
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance Hand Touching FV Edge API}]

Should the user generator instance support the API for "Hand Touching
FOV Edge" events the following methods become available.

This support can checked by invoking the inherited method
[method isCapableOf] for the capability name
[const hand-touching-fov-edge].

[list_begin definitions]

[comment ===============================================================]
[call [arg userInstanceCmd] [method set-callback-fovEdge] [arg cmd]...]
[call [arg userInstanceCmd] [method unset-callback-fovEdge]]

These methods define and remove a callback responding to edge touch
events, i.e. a hand coming into contact with the edge of the field of
view (a box).

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with four arguments added to it, the instance command,
the word "fovEdge", The id of the hand? (user?) causing the event, the
position of the hand in space, a timestamp, and the direction of the
edge that is touched on.

[comment {
	 The handle in the C-level callback is actually from a hands
	 generator. Let us ignore that for the moment, until we are
	 able to translate form a C handle to the Tcl instance command
	 and then maybe to the whole wrapper object.
}]

[para] The 3D-position is a 3-element list containing the x-, y-, and
z-coordinates, in this order.

[para] The timestamp is a floating point value in seconds.

[para] The direction is one of
[list_begin enumerated]
[enum] [const illegal]
[enum] [const left]
[enum] [const right]
[enum] [const up]
[enum] [const down]
[enum] [const forward]
[enum] [const backward]
[list_end]

[para] The result of the methods is an empty string.

[list_end]
