
This sections documents the class [cmd {::kinetcl recorder}], the
concrete class for all OpenNI recorder nodes.

[para] This class inherits from [cmd {::kinetcl base}]. See section
[sectref {Base}].

[para] A recorder watches the stream of sensor information in the
system and serializes it to a file. A player node may in the future
read this information and replay it.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl recorder}] [method new]]
[call [cmd {::kinetcl recorder}] [method create] [arg objname]]

This command creates a new recorder instance and returns the fully
qualified name of the instance command. The API provided by that
command, i.e. the set of available methods and their semantics is
described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg recorderInstanceCmd] [method destroy]]

This method destroys the recorder instance and releases all associated
resources, including the instance command. Note that resources used
by multiple instances are released only when the last instance using
them is destroyed.

[para] The result of the method is the empty string.

[list_end]
