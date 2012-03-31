
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Alternative Viewpoint}]

Should an instance support alternate viewpoints the following methods
become available.

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

[list_end]

[include cevents.inc]

[comment ===============================================================]
[vset NAME viewpoint]
[vset EARGS null]
[vset DESC {viewpoint changes, i.e. when the instance takes or drops the viewpoint of another node}]
[include callback.inc]
