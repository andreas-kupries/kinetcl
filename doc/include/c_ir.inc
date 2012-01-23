
This sections documents the class [cmd ::kinetcl::ir],
which provides instances of ir generators,
derived from generators,
derived from production nodes.

[para] ... describe ir generator ....

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd ::kinetcl::ir]]

This command creates a new ir generator instance and returns the
fully qualified name of the instance command. The API provided by that
command, i.e. the set of available methods and their semantics is
described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [method destroy]]

This method destroys the instance and releases all associated resources.
Note that resources used by multiple instances are released only when the
last instance using them is destroyed.

The result of the method is the empty string.

Afterward the instance command is deleted.

[list_end]
