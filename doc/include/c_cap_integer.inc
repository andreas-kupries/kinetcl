
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection [vset CAPTITLE]]

Should a production node support the [vset CAPNAME] API the following
methods become available.

This support can checked by invoking the inherited method
[method is-capable-of] for the capability name [const [vset CAPNAME]].

[list_begin definitions]
[comment ===============================================================]
[call [arg instanceCmd] [method [vset CAPNAME]]]

In this form the method returns the current state of the instance's
[vset CAPNAME] setting.

[para] The result is an integer.

[comment ===============================================================]
[call [arg instanceCmd] [method [vset CAPNAME]] [arg value]]

In this form the method changes the instance's [vset CAPNAME] setting
to the specified [arg value].

[para] The result is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method [vset CAPNAME]-range]]

This method returns a dictionary describing the allowed domain of
values for the capability. The keys and associated values are:

[list_begin definitions]
[def [const min]]
The value is an integer number, the minimal value the setting is
allowed to have.

[def [const max]]
The value is an integer number, the maximal value the setting is
allowed to have.

[def [const default]]
The value is an integer number, the default value the setting will
have after node construction.

[def [const step]]
The value is an integer number, the difference between two legal
values of the setting.

The difference between [const min] and [const max] is a multiple of
this value.

[def [const auto]]
A boolean value. If [const true] the setting supports automatic
adjustment during operation of the node, otherwise not.

[list_end]

[comment ===============================================================]
[call [arg instanceCmd] [method set-callback-[vset CAPEVENT]] [arg cmd]...]
[call [arg instanceCmd] [method unset-callback-[vset CAPEVENT]]]

These methods define and remove a callback responding to [vset CAPEVENT]
configuration changes.

[para] Setting a callback implicitly removes any previous callback set.

[para] The callback to invoke is specified as a command prefix, and
will be invoked with two arguments added to it, the instance command,
and the word "[vset CAPEVENT]", in this order.

[para] The result of the methods is an empty string.

[list_end]
