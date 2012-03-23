
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Frame Synchronization}]

Should an instance support frame synchronization the following methods
become available.

This support can checked by invoking the inherited method
[method is-capable-of] for the capability name [const framesync].

[list_begin definitions]
[comment ===============================================================]
[call [arg instanceCmd] [method can-sync-with] [arg node]]

This method tests if the instance is able to synchronize its
generation of frames with the the other production [arg node]. This
argument is the object command of another kinetcl instance.

[para] The result is a boolean value, [const true] if the viewpoint of
[arg node] is supported, and [const false] else.

[comment ===============================================================]
[call [arg instanceCmd] [method start-sync-with] [arg node]]

This method causes the instance's to synchronize its frame generation
with the other production [arg node]. This argument is the object
command of another kinetcl instance.

[para] The result of the method is an empty string. An error is thrown
if the instance is not able to synchronize with [arg node].

[comment ===============================================================]
[call [arg instanceCmd] [method stop-sync-with] [arg node]]

This method causes the instance's to decouple its frame generation
from the other production [arg node]. This argument is the object
command of another kinetcl instance.

[para] The result of the method is an empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method synced-with] [arg node]]

This method tests if the instance is currently synchronized to the
other production [arg node]. This argument is the object command of
another kinetcl instance.

[para] The result is a boolean value, [const true] if the instance is
synchronized to [arg node], and [const false] else.

[comment ===============================================================]
[vset NAME framesync]
[vset NUM 2]
[vset EARGS null]
[vset DESC {frame synchronization changes, i.e. when the instance starts or stops synchronization with another node.}]
[include callback.inc]

[list_end]
