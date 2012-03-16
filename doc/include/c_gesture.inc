
This sections documents the class [cmd {::kinetcl gesture}], the
concrete class for all OpenNI gesture generator nodes.

[para] This class inherits from [cmd {::kinetcl generator}] and its
superclasses. See section [sectref {Generator}].

[para] A genestur generator identifies and tracks gestures performed
by the users within the field of view of the sensor.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl gesture}] [method new]]
[call [cmd {::kinetcl gesture}] [method create] [arg objname]]

This command creates a new gesture generator instance and returns the
fully qualified name of the instance command. The API provided by that
command, i.e. the set of available methods and their semantics is
described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method destroy]]

This method destroys the gesture generator instance and releases all
associated resources, including the instance command. Note that
resources used by multiple instances are released only when the last
instance using them is destroyed.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method add-gesture] [arg gesture] [arg box]]

This method activates the gesture, i.e. causes the instance to start
looking for it in the input.

[para] The [arg box] describes the area where to look for it, in
real-world coordinates. It is a 2-element list of 3-element lists of
x-, y-, and z-coordinates. The 1st 3D coordinate describes the
left-bottom-near corner of the box, whereas the 2nd describes the
right-top-far corner.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method remove-gesture] [arg gesture]]

This method deactivates the gesture, i.e. causes the instance to stop
looking for it in the input.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method is-gesture] [arg gesture]]

This method tests if the named [arg gesture] is supported by the instance.

[para] The result is a boolean value, [const true] if the gesture is
supported, and [const false] else.

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method gesture-has-progress] [arg gesture]]

This method tests if the named [arg gesture] supports progess
reporting during recognition.

[para] The result is a boolean value, [const true] if the gesture
supports progress reporting, and [const false] else.

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method all-gestures]]

This method returns a list containing the names of all gestures
supported by the instance.

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method active-gestures]]

This method returns a list containing the names of all gestures
that are currently active.

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method set-callback-gestureRecognized] [arg cmd]...]
[call [arg gestureInstanceCmd] [method unset-callback-gestureRecognized]]

These methods define and remove a callback responding to gesture
recognition events.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with five arguments added to it, the instance command,
the word "gestureRecognized", the name of the recognized gesture, the
3D coordinates of the location where the gesture was recognized, and
the location of the hand which performed the gesture at the end of the
gesture, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method set-callback-gestureProgress] [arg cmd]...]
[call [arg gestureInstanceCmd] [method unset-callback-gestureProgress]]

These methods define and remove a callback responding to gesture
progress events.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with five arguments added to it, the instance command,
the word "gestureProgress", the name of the gesture progressing, the
current 3D coordinates of the hand performing the gesture, and the
percentage of the gesture already performed, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method set-callback-gestureChange] [arg cmd]...]
[call [arg gestureInstanceCmd] [method unset-callback-gestureChange]]

These methods define and remove a callback responding to gesture
change events, i.e when gestures are (de)activated.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with two arguments added to it, the instance command,
and the word "gestureChange", in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method set-callback-gestureStageComplete] [arg cmd]...]
[call [arg gestureInstanceCmd] [method unset-callback-gestureStageComplete]]

These methods define and remove a callback responding to gesture
stage completion events.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with four arguments added to it, the instance command,
the word "gestureStageComplete", the name of the gesture which
complete one of its stages, and the current 3D coordinates of the hand
performing the gesture, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg gestureInstanceCmd] [method set-callback-gestureStageReadyForNext] [arg cmd]...]
[call [arg gestureInstanceCmd] [method unset-callback-gestureStageReadyForNext]]

These methods define and remove a callback responding to gesture
stage readiness events.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with four arguments added to it, the instance command,
the word "gestureStageReadyForNext", the name of the gesture which is
ready for the recognition of the next of its stages, and the current
3D coordinates of the hand performing the gesture, in this order.

[para] The result of the methods is an empty string.
[list_end]
