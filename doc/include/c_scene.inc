
This sections documents the class [cmd {::kinetcl scene}], the concrete
class for all OpenNI scene analyzer nodes.

[para] This class inherits from [cmd {::kinetcl map}] and its
superclasses. See section [sectref {Map Generator}].

[para] A scene analyzer segments a scene, identifying the floor and
other connected areas (i.e. users) in the view of the sensor.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl scene}]]

This command creates a new scene analyzer instance and returns the
fully qualified name of the instance command. The API provided by that
command, i.e. the set of available methods and their semantics is
described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg sceneInstanceCmd] [method destroy]]

This method destroys the scene analyzer instance and releases all
associated resources, including the instance command.  Note that
resources used by multiple instances are released only when the last
instance using them is destroyed.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg sceneInstanceCmd] [method meta]]

This method returns a dictionary holding information about the scene
segmentation produced by the node. The keys found in this dictionary,
and the associated values are:

[list_begin definitions][comment --image-meta-data--]
[include c_meta_map.inc]
[list_end][comment ----------------image-meta-data--]

Notes:
[para] Scene segmentations are in pixel format [const grey16].

[comment ===============================================================]
[call [arg sceneInstanceCmd] [method map]]

This method returns a [package crimp] image of type [const grey16]
containing the current scene segmentation. Each pixel is labeled with
the id of the user it belongs to, or [const 0] if it is background.

[comment ===============================================================]
[call [arg sceneInstanceCmd] [method floor]]

This method returns a dictionary describing the floor, as a
combination of a point on the floor, plus the normal vector to specify
orientation. The two keys in the dictionary are

[list_begin definitions]
[def [const point]]
A point on the floor, in [term {real world}] coordinates. The value is
a 3-element list containing the x-, y-, and z-coordinates, in this
order.

[def [const normal]]
The normal vector describing the orientation. The value is a 3-element
list containing the [term {real world}] x-, y-, and z-coordinates, in
this order.

[list_end]
[list_end]
