
This sections documents the class [cmd {::kinetcl joints}], a class
providing proper event based tracking of user skeletons.

[para] This class inherits from [cmd {::kinetcl eventbase}] for the
overall management of the events it generates.
See section [sectref {Event Base}].

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl joints}] [method new] [opt [arg user]]]
[call [cmd {::kinetcl joints}] [method create] [arg objname] [opt [arg user]]]

This command creates a new instance of the class, either automatically
named ([method new]), or explicitly ([method create]).

The API provided by the instance, i.e. the set of available methods
and their semantics is described in the next subsection.

[para] If the argument [arg user] is specified then it must be an
instance of class [class {::kinetcl user}].
See section [sectref {User Generator}] for details. In the future we
[emph may] relax these restriction to require only API cmopatibility.

[para] If no such instance is specified the new instance will itself
create such an instance.

[para] This user generator is used to get the basic events for
tracking users and skeletons the instance will then transform into
more suitable form and events.

[para] Note that any instance methods invoked and not known to the
class (see below for the known API) are delegated to the user
generator for handling, making the instance look like an extended user
generator.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg instanceCmd] [method threshold]]

In this form the method returns the value of the confidence threshold
used to distinguish between good and ignorable joint locations. The
default is [const 0.5].

[comment ===============================================================]
[call [arg instanceCmd] [method threshold] [arg value]]

In this form the method configures the instance to use the new
[arg value] of the confidence threshold used to distinguish between
good and ignorable joint locations. This value must be a floating
point number in the range [const 0]..[const 1].

[comment ===============================================================]
[call [arg instanceCmd] [method get-generator]]

The method returns the instance command of the user generator
provinding the raw information about users and skeletons. This is
either the generator specified at instance construction time, or the
internally created generator.

[comment ===============================================================]
[call [arg instanceCmd] [method get-joint] [arg user] [arg joint]]

This method returns the location of the named [arg joint] for the
specified [arg user] (id).

[para] This information comes out of an internal cache maintained by
the instance, to avoid having to go to the underlying user generator.

[para] The result of the method is a 3D location in world coordinates.

[comment ===============================================================]
[call [arg instanceCmd] [method get-skeleton] [arg user]]

This method returns the location of all joints currently known for the
specified [arg user] (id).

[para] This information comes out of an internal cache maintained by
the instance, to avoid having to go to the underlying user generator.

[para] The result of the method is a dictionary mapping joint names to
3D locations in world coordinates.

[list_end]


[include events.inc]

[comment ===============================================================]
[vset NAME user-create]
[vset EARGS user]
[vset DESC {the appearance of new users in the scene}]
[include callback.inc]

[comment ===============================================================]
[vset NAME user-move]
[vset EARGS user]
[vset DESC {the user moving in the scene}]
[include callback.inc]

[comment ===============================================================]
[vset NAME user-destroy]
[vset EARGS user]
[vset DESC {the disappearance of users from the scene}]
[include callback.inc]

[comment ===============================================================]
[vset NAME joint-create]
[vset EARGS joint]
[vset DESC {the appearance of a user's joint (confident position)}]
[include callback.inc]

[comment ===============================================================]
[vset NAME joint-move]
[vset EARGS joint]
[vset DESC {the user's joint's movement in the scene}]
[include callback.inc]

[comment ===============================================================]
[vset NAME joint-destroy]
[vset EARGS jointd]
[vset DESC {the disappearance of a user's joint (non-confident position)}]
[include callback.inc]
