[comment ===============================================================]
[comment {
    Variables
    - NAME    Name of event
    - NUM     Number of argument, must include the automatic arguments (i.e. +2).
    - EARGS   Reference to a file describing the additional arguments.
    - DESC    Description of what the event is for.
}]

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method set-callback-[vset NAME]] [arg cmd]...]

This method defines a callback responding to
[vset DESC]

[para] Note that setting the callback removes any previously set callback.

[para] The callback is a command prefix and will be invoked with
[vset NUM] additional arguments, which are, in the order below:

[list_begin definitions]
[def [const [vset NAME]]] The name of the event
[def [arg instanceCmd]]   The instance generating the event
[include ev_[vset EARGS].inc]
[list_end]

[para] [emph Note] that callbacks are not told the actual state of the
instance. If this information is required then it is the callback's
responsibility to query the state using the appropriate query methods.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method unset-callback-[vset NAME]]]

This method removes the callback set with method
[method set-callback-[vset NAME]].

[para] The result of the method is an empty string.
