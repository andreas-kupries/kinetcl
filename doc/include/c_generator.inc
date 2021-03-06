
This sections documents the class [cmd {::kinetcl generator}], the (abstract) base
class for all OpenNI generator nodes.

[para] This class inherits from [cmd {::kinetcl base}]. See section
[sectref {Base}].

[para] They may have the following capabilities:
[list_begin enumerated]
[enum] [sectref {Alternative Viewpoint}]
[enum] [sectref {Frame Synchronization}]
[enum] [sectref {Mirror}]
[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl generator}] [method new]]
[call [cmd {::kinetcl generator}] [method create] [arg objname]]

This command creates a new instance of the generator.

Note that it is [emph impossible] to create such an instance on its
own. It can be done only as part of constructing the instance of a
concrete class.

The API provided by the instance, i.e. the set of available methods
and their semantics is described in the next subsection.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method start]]

This method causes the instance to start generating output. It implies
the activation of all dependencies as well.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method stop]]

This method causes the instance to stop generating output.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method active]]

This method tests if the instance is generating output.

[para] The result of the method is a boolean value, [const true] if the
instance is generating output, and [const false] else.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method update]]

This method causes the instance to update its output to the newest
available. If no new output was available the method blocks until this
happens.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method hasNew]]

This method tests if the instance has new output available it could be
updated to.  I.e. it checks if the method [method update] would block
or not.

[para] The result of the method is a boolean value, [const true] if
the instance has new data (i.e. [method update] would not block), and
[const false] else.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method isNew]]

This method tests if the instance's current input frame is new,
i.e. unchanged since the last call to method [method update].

[para] The result of the method is a boolean value, [const true] if
the instance if the current frame is still new, and [const false]
else.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method frame]]

This method returns the id of the input frame currently handled by the
instance.

[para] The result of the method is an integer number.

[comment ===============================================================]
[call [arg generatorInstanceCmd] [method time]]

This method returns the time of the input frame currently handled by
the instance, in microseconds.

[para] The result of the method is an integer number.

[list_end]

[include events.inc]

[comment ===============================================================]
[vset NAME active]
[vset EARGS null]
[vset DESC {activity changes, i.e. the instance starting and stopping the generation of output}]
[include callback.inc]

[comment ===============================================================]
[vset NAME newdata]
[vset EARGS null]
[vset DESC {the availability of new data, i.e the instance having new output available for the user}]
[include callback.inc]
