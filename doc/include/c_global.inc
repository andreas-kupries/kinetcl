
This sections documents the global commands in the
[namespace ::kinetcl] namespace and ensemble.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]

[list_begin definitions]

[comment ===============================================================]
[call [cmd {::kinetcl estart}]]

This command deactivates the event deferal, aka lockout mode.

Any OpenNI/kinetcl events which were prevented from entering Tcl's
event queue are now moved into it.

[para] The result of the command is the empty string.

[comment ===============================================================]
[call [cmd {::kinetcl estop}]]

This command activates the event deferal, aka lockout mode.

Any OpenNI/kinetcl events occuring while this mode is active are
prevented from entering Tcl's event queue until the next invokation of
[cmd {::kinetcl estop}].

[para] The result of the command is the empty string.

[comment ===============================================================]
[call [cmd {::kinetcl start}]]

This command activates data processing and generation in all known
generator nodes.

[para] The result of the command is the empty string.

[comment ===============================================================]
[call [cmd {::kinetcl stop}]]

This command deactivates data processing and generation in all known
generator nodes.

[para] The result of the command is the empty string.

[comment ===============================================================]
[call [cmd {::kinetcl waitUpdate}]]

This command waits for all generator nodes to have new data and then
updates them all.

[para] The result of the command is the empty string.


[comment ===============================================================]
[call [cmd {::kinetcl waitAnyUpdate}]]

This command waits for any of the generator nodes to have new data and
then updates them all.

[para] The result of the command is the empty string.

[comment ===============================================================]
[call [cmd {::kinetcl waitNoneUpdate}]]

This command updates all generator nodes, without any waiting.

[para] The result of the command is the empty string.

[comment ===============================================================]
[call [cmd {::kinetcl waitOneUpdate}] [arg node]]

This command waits for the specified generator [arg node] to have new
data and then updates all nodes.

[para] The result of the command is the empty string.

[comment ===============================================================]
[call [cmd {::kinetcl errorstate}]]

This command returns the global error state of OpenNI as string.

[comment ===============================================================]
[call [cmd {::kinetcl mirror}] [opt [arg bool]]]

This command returns the current value of the global mirror flag.

If the argument is specified the global mirror flag is set to its
value, and all existing nodes supporting mirroring are reconfigured to
reflect the new state.

[list_end]
