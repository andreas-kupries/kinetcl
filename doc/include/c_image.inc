
This sections documents the class [cmd {::kinetcl image}], the
concrete class for all OpenNI image generator nodes.

[para] This class inherits from [cmd {::kinetcl map}] and its
superclasses. See section [sectref {Map Generator}].

[para] An image generator is a map generator providing plain images,
where each pixel value describes the color (or luminance) of the pixel.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl image}] [method new]]
[call [cmd {::kinetcl image}] [method create] [arg objname]]

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


[comment ===============================================================]
[call [arg imageInstanceCmd] [method formats]]

This method returns a list of the pixel formats supported by the node.

[para] For the list of possible pixel formats see below, under method
[method meta].

[comment ===============================================================]
[call [arg imageInstanceCmd] [method format] [opt [arg format]]]

This method returns the name of the currently active pixel format.
If the argument [arg format] is present the node is reconfigured to 
report the images in the specified format.

[para] For the list of possible pixel formats see below, under method
[method meta].

[comment ===============================================================]
[call [arg imageInstanceCmd] [method meta]]

This method returns a dictionary holding information about the image
maps produced by the node. The keys found in this dictionary, and the
associated values are:

[list_begin definitions][comment --image-meta-data--]
[include c_meta_map.inc]
[list_end][comment ----------------image-meta-data--]

Notes:
[para] Image maps are usually in pixel format [const rgb24].

[comment ===============================================================]
[call [arg imageInstanceCmd] [method map]]

This method returns a [package crimp] image containing the current
image map. The crimp type of the image depends on the currently active
pixel format:

[list_begin definitions]
[def [const rgb24]]  --> [const rgb]
[def [const grey8]]  --> [const grey8]
[def [const grey16]] --> [const grey16]
[list_end]

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method set-callback-pixelformat] [arg cmd]...]
[call [arg generatorInstanceCmd] [method unset-callback-pixelformat]]

These methods define and remove a callback responding to changes in
the active pixel format of the node.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with two arguments added to it, the instance command,
and the word "pixelformat", in this order.

[para] [emph Note] that the callback is not told the actual state of
the instance. If this information is required then it is the
callback's responsibility to query the state, using the interogatory
method [method format].

[para] The result of the methods is an empty string.

[list_end]
