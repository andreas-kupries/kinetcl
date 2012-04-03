
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection [vset CAPTITLE]]

Should an instance support the [vset CAPNAME] setting the following
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

[list_end]

[include cevents.inc]

[comment ===============================================================]
[vset NAME [vset CAPEVENT]]
[vset EARGS null]
[vset DESC "[vset CAPEVENT] changes, i.e. reconfiguration of the instance's [vset CAPEVENT] setting"]
[include callback.inc]
