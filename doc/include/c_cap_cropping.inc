
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Cropping}]

Should an instance support cropping the following methods become
available.

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

[list_end]

[include cevents.inc]

[comment ===============================================================]
[vset NAME cropping]
[vset EARGS null]
[vset DESC {reconfiguration of the instance's crop region}]
[include callback.inc]
