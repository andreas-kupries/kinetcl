
This sections documents the class [cmd ::kinetcl::script],
which provides instances of scripts,
derived from generators,
derived from production nodes.

[para] ... describe script generator ....

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd ::kinetcl::script]]

This command creates a new script instance and returns the fully
qualified name of the instance command. The API provided by that
command, i.e. the set of available methods and their semantics is
described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg scriptInstanceCmd] [method destroy]]

This method destroys the script instance and releases all associated
resources, including the instance command. Note that resources used
by multiple instances are released only when the last instance using
them is destroyed.

[para] The result of the method is the empty string.

[list_end]
