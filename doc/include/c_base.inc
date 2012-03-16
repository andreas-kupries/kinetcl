
This sections documents the class [cmd {::kinetcl base}], the (abstract) base
class for all OpenNI production nodes.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl base}] [method new]]
[call [cmd {::kinetcl base}] [method create] [arg objname]]

This command creates a new instance of the base.

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
[call [arg baseInstanceCmd] [method capabilities] [opt [option -all]]]

This method returns the capabilities of the instance, or, if option
[option -all] was specified, the set of all possible capabilities.

[para] The result is a list containing the names of the capabilities.

[comment ===============================================================]
[call [arg baseInstanceCmd] [method is-capable-of] [arg capability]]

This method checks if the named capability is supported by the
instance or not.

[para] The result is a boolean value, [const true] if the capability
is supported, and [const false] else.



[comment ===============================================================]
[call [arg baseInstanceCmd] [method node-info]]

This method returns a dictionary containing OpenNI's description of the
node. They keys of the dictinary, and the associated values are

[list_begin definitions]
[def [const type]]
The OpenNI type of the node, which is either one of
[list_begin itemized][comment -node-types-]
[item] invalid
[item] device
[item] depth
[item] image
[item] audio
[item] ir
[item] user
[item] recorder
[item] player
[item] gesture
[item] scene
[item] hands
[item] codec
[item] production
[item] generator
[item] map
[item] script
[list_end][comment -node-types-]
or an integer number. The latter is used for unknown custom types
OpenNI has no name for.

[def [const vendor]]
The name of the vendor supplying the library which implements the
node.

[def [const name]]
The name OpenNI has given to the node. This is the same as returned by
method [method node-name].

[def [const version]]
The version of the library implementing the node (see also the key
[const vendor]) as a 4-element list containing major, minor version
number, maintenance id, and build number, in this order.

[def [const create]]
The node's creation detail information.

[list_end]

[comment ===============================================================]
[call [arg baseInstanceCmd] [method node-name]]

This method returns a string holding the OpenNI name of the node.

[list_end]
