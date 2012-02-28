
This sections documents the class [cmd ::kinetcl::image], the
concrete class for all OpenNI image generator nodes.

[para] This class inherits from [cmd ::kinetcl::map] and its
superclasses. See section [sectref {Map Generator}].

[para] An image generator is a map generator providing plain images,
where each pixel value describes the color (or luminance) of the pixel.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd ::kinetcl::image]]

This command creates a new image generator instance and returns the
fully qualified name of the instance command. The API provided by that
command, i.e. the set of available methods and their semantics is
described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg imageInstanceCmd] [method destroy]]

This method destroys the image generator instance and releases all
associated resources, including the instance command. Note that
resources used by multiple instances are released only when the last
instance using them is destroyed.

[para] The result of the method is the empty string.

[list_end]
