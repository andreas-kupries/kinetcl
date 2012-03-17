
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Anti-Flicker}]

Should a production node support the anti-flicker API the following
methods become available.

This support can checked by invoking the inherited method
[method is-capable-of] for the capability name [const antiflicker].

[list_begin definitions]
[comment ===============================================================]
[call [arg instanceCmd] [method frequency]]

In this form the method returns the current anti-flicker settings.

[para] The result is either the string [const off], or the powerline
frequency the node is synchronized to.

[comment ===============================================================]
[call [arg instanceCmd] [method crop] [arg frequency]]

In this form the method changes the anit-flicker settings.

The allowed values for [arg frequency] are [const 50], [const 60], and
[const off]. The latter disables the anti-flicker system.

[para] The result is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method set-callback-frequency] [arg cmd]...]
[call [arg instanceCmd] [method unset-callback-frequency]]

These methods define and remove a callback responding to anti-flicker
configuration changes.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with two arguments added to it, the instance command,
and the word "frequency", in this order.

[para] The result of the methods is an empty string.

[list_end]
