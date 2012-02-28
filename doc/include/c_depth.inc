
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

[list_end]
