
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Mirror}]

Should an instance support mirroring the following methods become
available.

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
[vset NAME mirror]
[vset NUM 2]
[vset EARGS null]
[vset DESC {reconfiguration of the instance's mirror flag.}]
[include callback.inc]

[list_end]
