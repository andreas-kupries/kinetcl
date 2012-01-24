
This sections documents the class [cmd ::kinetcl::ir],
which provides instances of ir image generators,
derived from generators,
derived from production nodes.

[para] ... describe ir generator ....

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd ::kinetcl::ir]]

This command creates a new ir image generator instance and returns the
fully qualified name of the instance command. The API provided by that
command, i.e. the set of available methods and their semantics is
described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg irIstanceCmd] [method destroy]]

This method destroys the ir image generator instance and releases all
associated resources, including the instance command. Note that
resources used by multiple instances are released only when the last
instance using them is destroyed.

[para] The result of the method is the empty string.

[list_end]
