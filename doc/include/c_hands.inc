
This sections documents the class [cmd {::kinetcl hands}], the concrete
class for all OpenNI hand generator nodes.

[para] This class inherits from [cmd {::kinetcl generator}] and its
superclasses. See section [sectref {Generator}].

[para] A hand generator identifies and tracks the hands of the users
within the field of view of the sensor.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl hands}] [method new]]
[call [cmd {::kinetcl hands}] [method create] [arg objname]]

This command creates a new hands generator instance and returns the
fully qualified name of the instance command. The API provided by that
command, i.e. the set of available methods and their semantics is
described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg handsInstanceCmd] [method destroy]]

This method destroys the hands generator instance and releases all
associated resources, including the instance command. Note that
resources used by multiple instances are released only when the last
instance using them is destroyed.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method set-smoothing] [arg factor]]

This method sets the smoothing [arg factor] for hand tracking, a
floating point value between [const 0] and [const 1]. The former
disables smoothing, the latter implies infinite smoothing.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method start-tracking] [arg point]]

This method activates the tracking of a hand at the [arg point].

The point must be a 3-element list containing the X, Y, and Z
coordinates, in this order.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method stop-tracking] [arg id]]

This method stops tracking of the hand specified by the [arg id].

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method stop-tracking-all]]

This method stops the tracking of all hands known to the node.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method set-callback-handCreate] [arg cmd]...]
[call [arg generatorInstanceCmd] [method unset-callback-handCreate]]

These methods define and remove a callback responding to hand creation
events, i.e. the node starting to track an additional hand.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with five arguments added to it, the instance command,
the word "handCreate", the id of the hand, the location of the hand,
and a timestamp, in this order.

[para] The location is a 3-element list containing the X, Y, and Z
coordinates of the hand, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method set-callback-handUpdate] [arg cmd]...]
[call [arg generatorInstanceCmd] [method unset-callback-handUpdate]]

These methods define and remove a callback responding to hand update
events, i.e. when a tracked hand moves to a new location.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with five arguments added to it, the instance command,
the word "handUpdate", the id of the hand, the new location of the
hand, and a timestamp, in this order.

[para] The location is a 3-element list containing the X, Y, and Z
coordinates of the hand, in this order.

[para] The result of the methods is an empty string.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method set-callback-handDestroy] [arg cmd]...]
[call [arg generatorInstanceCmd] [method unset-callback-handDestroy]]

These methods define and remove a callback responding to hand
destruction events, i.e. when a tracked hand disappears.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with four arguments added to it, the instance command,
the word "handDestroy", the id of the destroyed hand, and a timestamp,
in this order.

[para] The result of the methods is an empty string.

[list_end]
