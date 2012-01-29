
This sections documents the class [cmd ::kinetcl::base], the (abstract) base
class for all OpenNI production nodes.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd ::kinetcl::base] [method new]]
[call [cmd ::kinetcl::base] [method create] [arg objname]]

This command creates a new instance of the base.

Note that it is [emph impossible] to create such an instance on its
own. It can be done only as part of the constructing the instance of a
concrete class.

The API provided by the instance, i.e. the set of available methods
and their semantics is described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg userInstanceCmd] [method capabilities] [opt [option -arg]]]

This method returns the capabilities of the instance, or, if option
[option -all] was specified, the set of all possibile
capabilities.

[para] The result is a list containing the names of the capabilities.

[comment ===============================================================]
[call [arg userInstanceCmd] [method isCapableOf] [arg capability]]

This method checks if the named capability is supported by the
instance or not.

[para] The result is a boolean value, [const true] if the capability
is supported, and [const false] else.

[list_end]
