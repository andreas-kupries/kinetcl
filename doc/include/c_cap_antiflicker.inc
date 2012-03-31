
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Anti-Flicker}]

Should an instance support anti-flicker behaviour the following
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

[list_end]

[include cevents.inc]

[comment ===============================================================]
[vset NAME frequency]
[vset EARGS null]
[vset DESC {reconfiguration of the instance's powerline frequency setting}]
[include callback.inc]
