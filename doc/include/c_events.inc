
This sections documents the class [cmd {::kinetcl ventbase}], a base
class supplying general event management facilities.

[para] This class has no superclasses, i.e it inherit nothing.

[para] It itself is used by the classes
[cmd {::kinetcl nodeevents}] (described in section
[sectref {Node Events}]) and [cmd {::kinetcl joints}] (described in
section [sectref {Joint Events}].

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl eventbase}] [method new]]
[call [cmd {::kinetcl eventbase}] [method create] [arg objname]]

This command creates a new instance of the class, either automatically
named ([method new]), or explicitly ([method create]).

The API provided by the instance, i.e. the set of available methods
and their semantics is described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg instanceCmd] [method bind] [arg event] [arg cmdprefix]]

This method binds the command prefix [arg cmdprefix] to the specified
[arg event] and returns an opaque token for the binding.

[para] The system ensures that everybody with an interest in the event
(i.e. having to know if there are bindings or not) is notified and can
take action.

[para] The result of the method is an opaque token.

[para] The command prefix is expected to have the following signature:

[list_begin definitions]
[call [cmd "{*}\$cmdprefix"] [arg event] [arg instance] [arg details]]
[list_begin arguments]
[arg event]
The name of the event which triggered the command. First argument,
thus allowing it to be used as a sub-command or method of an ensemble
or object instance.

[arg instance]
The object instance generating the event.

[arg details]
Event specific data with more information about the event.

[list_end]
[list_end]

[comment ===============================================================]
[call [arg instanceCmd] [method unbind] [arg token]]

This method removes the event binding represented by the opaque [arg token],
a result of a call to method [method bind] above.

[para] The system ensures that everybody with an interest in the event
(i.e. having to know if there are bindings or not) is notified and can
take action.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method generate] [arg event] [arg details]]

This method generates the named event, ensuring that all bindings are
called and supplied with the given [arg details]. The structure of
said details depends on the event in question.

[comment ===============================================================]
[call [arg instanceCmd] [method bound]]

This is an abstract method which can be overridden by derived classes.
As is it does nothing.

[para] It is invoked when the instance becomes known as having
bindings for any event.

[para] The result of the method is ignored.

[comment ===============================================================]
[call [arg instanceCmd] [method unbound]]

This is an abstract method which can be overridden by derived classes.
As is it does nothing.

[para] It is invoked when the instance becomes known as having no
bindings anymore, for no events.

[para] The result of the method is ignored.

[comment ===============================================================]
[call [arg instanceCmd] [method event-bound] [arg event]]

This is an abstract method which can be overridden by derived classes.
As is it does nothing.

[para] It is invoked when the named event becomes known as having
bindings.

[para] The result of the method is ignored.

[comment ===============================================================]
[call [arg instanceCmd] [method event-unbound] [arg event]]

This is an abstract method which can be overridden by derived classes.
As is it does nothing.

[para] It is invoked when the named event becomes known as having no
bindings anymore.

[para] The result of the method is ignored.

[comment ===============================================================]
[call [arg instanceCmd] [method Register] [arg events]]

This is a method for use by derived classes. It takes a list of event
names and arranges for notification when bindings to the instance and
these events come into existence or are removed.

[para] This information is used to drive the invokations of the
abstract methods above, i.e. [method bound], [method unbound],
[method event-bound], and [method event-unbound].

[para] The result of the method is an empty string.

[list_end]
