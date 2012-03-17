
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Mirror}]

Should a production node support the mirror API the following methods
become available.

This support can checked by invoking the inherited method
[method is-capable-of] for the capability name [const mirror].

[list_begin definitions]
[comment ===============================================================]
[call [arg instanceCmd] [method mirror]]

In this form the method returns the current state of the instance's
mirror flag.

[para] The result is a boolean value, [const true] if the instance
generates mirrored frames, and [const false] else.

[comment ===============================================================]
[call [arg instanceCmd] [method mirror] [arg bool]]

In this form the method (un)sets the instance's mirror flag.

[para] The result is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method set-callback-mirror] [arg cmd]...]
[call [arg instanceCmd] [method unset-callback-mirror]]

These methods define and remove a callback responding to mirror
configuration changes, i.e. when the instance's mirror flag is
reconfigured.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with two arguments added to it, the instance command,
and the word "mirror", in this order.

[para] The result of the methods is an empty string.

[list_end]
