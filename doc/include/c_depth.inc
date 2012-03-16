
[comment {not implemented yet: conversion real-word <-> projective coordinates}]

This sections documents the class [cmd ::kinetcl::generator], the
concrete class for all OpenNI depth generator nodes.

[para] This class inherits from [cmd ::kinetcl::generator] and its
superclasses. See section [sectref {Generator}].

[para] A depth generator is a generator providing depth maps,
i.e. images where each pixel value describes the distance of the pixel
from the sensor.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd ::kinetcl::depth]]

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
from the sensor.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method set-callback-depthfov] [arg cmd]...]
[call [arg generatorInstanceCmd] [method unset-callback-depthfov]]

These methods define and remove a callback responding to changes in
the field of view of the node.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with two arguments added to it, the instance command,
and the word "depthfov", in this order.

[para] [emph Note] that the callback is not told the actual state of
the instance. If this information is required then it is the
callback's responsibility to query the state, using the interogatory
method [method fov].

[para] The result of the methods is an empty string.

[list_end]
