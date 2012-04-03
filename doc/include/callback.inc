[comment ===============================================================]
[comment {
    Variables
    - NAME    Name of event
    - EARGS   Reference to a file describing the detail dictionary.
    - DESC    Description of what the event is for.
}]

[list_begin definitions]
[def [const [vset NAME]]]

This event is generated in response to [vset DESC].

[para] [include ev_[vset EARGS].inc]

[para] [emph Note] that events are not told the actual state of the
instance. If this information is required then it is the receiver's
responsibility to query the state using the appropriate query methods.

[list_end]
