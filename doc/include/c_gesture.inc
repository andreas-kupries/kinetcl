
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
[call [arg gestureInstanceCmd] [method add-gesture] [arg gesture] [opt [arg box]]]

This method activates the gesture, i.e. causes the instance to start
looking for it in the input.

[para] The [arg box] describes the area where to look for it, in
real-world coordinates. It is a 2-element list of 3-element lists of
x-, y-, and z-coordinates. The 1st 3D coordinate describes the
left-bottom-near corner of the box, whereas the 2nd describes the
right-top-far corner.

[para] If not specified the box encompasses the whole field of view.

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
[vset NAME gesture-recognized]
[vset NUM 5]
[vset EARGS gesture_r]
[vset DESC {the recognition of named a gesture.}]
[include callback.inc]

[comment ===============================================================]
[vset NAME gesture-progress]
[vset NUM 5]
[vset EARGS gesture_p]
[vset DESC {the system's progress in recognizing a gesture.}]
[include callback.inc]

[comment ===============================================================]
[vset NAME gesture]
[vset NUM 3]
[vset EARGS null]
[vset DESC {the (de)activation of the recognition of named gestures.}]
[include callback.inc]

[comment ===============================================================]
[vset NAME gesture-stage-complete]
[vset NUM 4]
[vset EARGS gesture_s]
[vset DESC {the completion of stages in a gesture's recognition}]
[include callback.inc]

[comment ===============================================================]
[vset NAME gesture-stage-ready-for-next]
[vset NUM 4]
[vset EARGS gesture_s]
[vset DESC {the system's readiness to enter the next stage in the recognition of a gesture.}]
[include callback.inc]

[list_end]
