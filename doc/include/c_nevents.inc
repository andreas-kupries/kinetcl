
This sections documents the class [cmd {::kinetcl nodeevents}], a base
class supplying the event management for all OpenNI production nodes
dervided from class [cmd {::kinetcl base}] described in section
[sectref Base].

[para] This class inherits from [cmd {::kinetcl eventbase}] for the
overall management of events. See section [sectref {Event Base}].

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl nodeevents}] [method new]]
[call [cmd {::kinetcl nodeevents}] [method create] [arg objname]]

This command creates a new instance of the class, either automatically
named ([method new]), or explicitly ([method create]).

The API provided by the instance, i.e. the set of available methods
and their semantics is described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg instanceCmd] [method SetupEventsOf] [arg node]]

This method introspects the C-level OpenNI instance [arg node] and
registers all callbacks it exposes (via a method pair
[method set-callback-*], [method unset-callback-*]) as events the instance
is able to generate.

[para] It further remembers the mapping from event names to the
[arg node] instances generating them.

[para] The result of the method is an empty string.

[comment {
[comment ===============================================================]
[call [arg instanceCmd] [method event-bound] [arg event]]

This internal method overrides the abstract method of the base class
[cmd {::kinetcl eventbase}] to receive knowledge of when an event is
bound to and thus requiring the generation of said event, which it
arranges for.

[para] This method is not for public use.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method event-unbound] [arg event]]

This internal method overrides the abstract method of the base class
[cmd {::kinetcl eventbase}] to receive knowledge of when an event is
not bound any more and thus requiring the generation of said event to
be shut down, which it arranges for.

[para] This method is not for public use.

[para] The result of the method is an empty string.
}]

[list_end]
