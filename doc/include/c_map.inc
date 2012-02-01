
This sections documents the class [cmd ::kinetcl::map], the (abstract) base
class for all OpenNI map generator nodes.

[para] This class inherits from [cmd ::kinetcl::generator] and its
superclasses.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd ::kinetcl::generator] [method new]]
[call [cmd ::kinetcl::generator] [method create] [arg objname]]

This command creates a new instance of the map generator.

Note that it is [emph impossible] to create such an instance on its
own. It can be done only as part of constructing the instance of a
concrete class.

The API provided by the instance, i.e. the set of available methods
and their semantics is described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method bytes-per-pixel]]

This method returns the number of bytes per pixel in the map.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method modes]]

This method returns the map output modes supported by the instance.

[para] The result of the method is a list of modes. Each mode is a
3-element list reporting the x- and y-resolution of the map in pixels,
and the associated frame rate in frames per second, in this order. All
elements are integer numbers.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method mode]]

This form of the method reports the currently set map output mode.

[para] The result of the method is a 3-element list reporting the x-
and y-resolution of the map in pixels, and the associated frame rate
in frames per second, in this order. All elements are integer numbers.

[call [arg generatorInstanceCmd] [method mode] [arg xres] [arg yres] [arg fps]]

This form of the method changes the map output mode to the specified
resolution and frame rate. The method throws an error if the
combination is not supported by the instance.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method set-callback-mode] [arg cmd]...]
[call [arg generatorInstanceCmd] [method unset-callback-mode]]

These methods define and remove a callback responding to mode change
events, i.e. the instance changing the its output mode.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with two arguments added to it, the instance command,
and the word "mode", in this order.

[para] The result of the methods is an empty string.

[list_end]
