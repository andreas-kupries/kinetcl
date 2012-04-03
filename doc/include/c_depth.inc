
[comment {not implemented yet: conversion real-word <-> projective coordinates}]

This sections documents the class [cmd {::kinetcl generator}], the
concrete class for all OpenNI depth generator nodes.

[para] This class inherits from [cmd {::kinetcl generator}] and its
superclasses. See section [sectref {Generator}].

[para] A depth generator is a generator providing depth maps,
i.e. images where each pixel value describes the distance of the pixel
from the sensor.

[comment {[para] They may have the following capabilities:
[list_begin enumerated]
[enum] [sectref {User Position}]
[list_end]}]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl depth}] [method new]]
[call [cmd {::kinetcl depth}] [method create] [arg objname]]

This command creates a new depth generator instance and returns the
fully qualified name of the instance command. The API provided by that
command, i.e. the set of available methods and their semantics is
described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg depthInstanceCmd] [method destroy]]

This method destroys the depth generator instance and releases all
associated resources, including the instance command. Note that
resources used by multiple instances are released only when the last
instance using them is destroyed.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg depthInstanceCmd] [method max-depth]]

This method returns the max depth the node is able to generate. The
result is an integer number.

[comment ===============================================================]
[call [arg depthInstanceCmd] [method fov]]

This method returns the field of view the node is able to generate, in
radians. The result is a 2-element list containing the horizontal and
vertical fields of view, in this order.

[comment ===============================================================]
[call [arg depthInstanceCmd] [method meta]]

This method returns a dictionary holding information about the depth
maps produced by the node. The keys found in this dictionary, and the
associated values are:

[list_begin definitions][comment --depth-meta-data--]
[include c_meta_map.inc]

[def [const max-depth]]
The max depth the node is able to generate. An integer number.
This is the same value as returned by method [method max-depth].

[list_end][comment ----------------depth-meta-data--]

Notes:
[para] Depth maps are in pixel format [const grey16].

[comment ===============================================================]
[call [arg depthInstanceCmd] [method map]]

This method returns a [package crimp] image of type [const grey16]
where the value of each pixel represents the distance of the pixel
from the sensor, in millimeters.

[comment ===============================================================]
[call [arg depthInstanceCmd] [method projective2world] [arg point]...]

This method converts one or more 3D points from sensor coordinates to
real world coordinates.

[para] The result of the method is a list holding the conversion
results. Each point in both arguments and result is a 3-element list
containing the point's X-, Y-, and Z-coordinates, in this order.

[comment ===============================================================]
[call [arg depthInstanceCmd] [method world2projective] [arg point]...]

This method converts one or more 3D points from real world coordinates
to sensor coordinates.

[para] The result of the method is a list holding the conversion
results. Each point in both arguments and result is a 3-element list
containing the point's X-, Y-, and Z-coordinates, in this order.

[list_end]

[include events.inc]

[comment ===============================================================]
[vset NAME depthfov]
[vset EARGS null]
[vset DESC {depthfov changes, i.e. reconfiguration of the device's field of view}]
[include callback.inc]
