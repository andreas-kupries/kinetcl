
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Alternative Viewpoint}]

Should a production node support the alternate viewpoint API the
following methods become available.

This support can checked by invoking the inherited method
[method is-capable-of] for the capability name
[const alternative-viewpoint].

[list_begin definitions]
[comment ===============================================================]
[call [arg instanceCmd] [method supports-view] [arg node]]

This method tests if the instance is able to use the viewpoint of the
the other production [arg node]. This argument is the object command
of another kinetcl instance.

[para] The result is a boolean value, [const true] if the viewpoint of
[arg node] is supported, and [const false] else.

[comment ===============================================================]
[call [arg instanceCmd] [method set-view] [arg node]]

This method sets the instance's viewpoint to the view of the other
production [arg node]. This argument is the object command of another
kinetcl instance.

[para] The result of the method is an empty string. An error is
thrown if the [arg node]'s viewpoint is not supported.

[comment ===============================================================]
[call [arg instanceCmd] [method reset-view]]

This method sets the instance's viewpoint back to its own viewpoint.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method using-view] [arg node]]

This method tests if the instance is currently using the viewpoint of
the other production [arg node]. This argument is the object command
of another kinetcl instance.

[para] The result is a boolean value, [const true] if the viewpoint of
[arg node] is in use, and [const false] else.

[comment ===============================================================]
[call [arg instanceCmd] [method set-callback-viewpoint] [arg cmd]...]
[call [arg instanceCmd] [method unset-callback-viewpoint]]

These methods define and remove a callback responding to viewpoint
configuration changes, i.e. when the viewpoint of a node is changed.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with two arguments added to it, the instance command,
and the word "viewpoint", in this order.

[para] The result of the methods is an empty string.

[list_end]
