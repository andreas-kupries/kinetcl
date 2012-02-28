
This sections documents the class [cmd ::kinetcl::scene], the concrete
class for all OpenNI scene analyzer nodes.

[para] This class inherits from [cmd ::kinetcl::map] and its
superclasses. See section [sectref {Map Generator}].

[para] A scene analyzer segments a scene, identifying the floor and
other connected areas in the view of the sensor.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd ::kinetcl::scene]]

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

[list_end]
