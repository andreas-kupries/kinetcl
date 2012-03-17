
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Cropping}]

Should a production node support the cropping API the following
methods become available.

This support can checked by invoking the inherited method
[method is-capable-of] for the capability name [const cropping].

[list_begin definitions]
[comment ===============================================================]
[call [arg instanceCmd] [method crop]]

In this form the method returns the current crop settings.

[para] The result is a list of 4-elements containing the x- and
y-offset of the crop rectangle, and its horizontal and vertical
dimensions, in this order.

[comment ===============================================================]
[call [arg instanceCmd] [method crop] [arg x] [arg y] [arg w] [arg h]]

In this form the method sets the crop rectangle to the specified x-
and y-offset of the crop rectangle, and its horizontal and vertical
dimensions

[para] The result is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method uncrop]]

This method deactivates any croppping set on the instance.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method set-callback-cropping] [arg cmd]...]
[call [arg instanceCmd] [method unset-callback-cropping]]

These methods define and remove a callback responding to cropping
configuration changes, i.e. when the instance's crop settings change.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with two arguments added to it, the instance command,
and the word "cropping", in this order.

[para] The result of the methods is an empty string.

[list_end]
