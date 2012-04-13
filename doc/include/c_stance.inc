
This sections documents the class [cmd {::kinetcl stance}], a class
for the recognition of [term stances], also known as [term poses] or
[term {body gestures}]. Events are generated whenever a user enters or
leaves a stance.

[para] This was in general inspired by the concept of
[uri http://projects.ict.usc.edu/mxr/faast/ {FAAST body gestures}]
mentioned at [uri http://fivedots.coe.psu.ac.th/~ad/jg/nui1610/index.html].

[para] This class inherits from [cmd {::kinetcl eventbase}] for the
overall management of the events it generates.
See section [sectref {Event Base}].

[para] Instances of the class rely on an external instance of class
[cmd {::kinetcl joints}] (See section [sectref {Joint Events}]) and
its events for the tracking of users and their skeleton joints.

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Class API}]
[list_begin definitions]
[call [cmd {::kinetcl stance}] [method new] [arg joints]]
[call [cmd {::kinetcl stance}] [method create] [arg objname] [arg joints]]

This command creates a new instance of the class, either automatically
named ([method new]), or explicitly ([method create]).

The API provided by the instance, i.e. the set of available methods
and their semantics is described in the next subsection.

[para] The [arg joints] argument must be a joint tracking object which
is API compatible to instances of class [class {::kinetcl joints}].

[para] This tracker is monitored for the creation, movement and
destruction of users, in response to which the referenced user and its
joints are run through the stance recognizer.

[list_end]

[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Instance API}]
[list_begin definitions]

[comment ===============================================================]
[call [arg instanceCmd] [method add] [arg name] [arg script]]

This method defines a new stance to be recognized by the instance,
identified by [arg name]. The [arg script] is the recognizer for the
stance and is invoked whenever a user moved, as this may have caused
her to either enter or exit the stance.

[para] The context and commands available to this script are explained
in detail in section [sectref {Stance Recognition Language}].

[para] The script has to return a boolean value, [const true] if the
stance is recognized, and [const false] otherwise.

[para] Events are send whenever this information changes (per-user).

[para] Note that a user can be in multiple stances at the same time.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method remove] [arg name]]

This method removes the [arg name]d stance from the instance, stopping
its future recognition.

[para] The result of the method is the empty string.

[comment ===============================================================]
[call [arg instanceCmd] [method measure] [arg name] [arg script]]

This method extends the gesture recognition language used by the
instance with a [arg name]d measure(ment), a cacheable piece of
information about a user's skeleton.

[para] The value of the measure is computed once, per user, by
invoking the [arg script]. The result of the script is the value of
the measurement.

[para] The context and commands available to this script are explained
in detail in section [sectref {Stance Recognition Language}].

[para] The set of predefined measures is explained in section
 [sectref {Predefined Measurements}].

[para] The result of the method is the empty string.

[list_end]


[include events.inc]

[comment ===============================================================]
[vset NAME stance-enter]
[vset EARGS stance]
[vset DESC {a user entering a recognized stance}]
[include callback.inc]

[comment ===============================================================]
[vset NAME stance-exit]
[vset EARGS stance]
[vset DESC {a user leaving a recognized stance}]
[include callback.inc]

[subsection {Stance Recognition Language}]

All gesture recogniton and measurement scripts are executed within a
namespace which provides the commands below:

[list_begin definitions]
[def Math]
All of Tcl's builtin math functions and operators.

[def Measurements]
All named measurements of the instance running the script, as commands
taking no arguments and returning the value of the measurement.

[def Skeleton][list_begin definitions][comment ===============Skeleton=]
[call [cmd head            ]]
[call [cmd neck            ]]
[call [cmd torso           ]]
[call [cmd waist           ]]
[call [cmd left-collar     ]]
[call [cmd left-shoulder   ]]
[call [cmd left-elbow      ]]
[call [cmd left-wrist      ]]
[call [cmd left-hand       ]]
[call [cmd left-fingertip  ]]
[call [cmd left-hip        ]]
[call [cmd left-knee       ]]
[call [cmd left-ankle      ]]
[call [cmd left-foot       ]]
[call [cmd right-collar    ]]
[call [cmd right-shoulder  ]]
[call [cmd right-elbow     ]]
[call [cmd right-wrist     ]]
[call [cmd right-hand      ]]
[call [cmd right-fingertip ]]
[call [cmd right-hip       ]]
[call [cmd right-knee      ]]
[call [cmd right-ankle     ]]
[call [cmd right-foot      ]]

These commands return the location of the named joint in world
coordinates, for the user the script is invoked for.

If the joint is not defined for that user, the script is aborted, and
the gesture's enter/exit state is not changed.

[list_end][comment ===========================================Skeleton=]

[def {Distances}][list_begin definitions][comment ===========Distances=]

[call [cmd distance]        [arg jointa] [arg jointb]]
[call [cmd distance_side]   [arg jointa] [arg jointb]]
[call [cmd distance_height] [arg jointa] [arg jointb]]
[call [cmd distance_depth]  [arg jointa] [arg jointb]]

In this form the commands take the names of two joints, determine
their locations and then compute the euclidean distance between them,
or the distance along the named axes.

[para] For the names of the possible joints see the command names
above.

[para] The result of the commands is a floating point value, the
computed distance.

[call [cmd distance]        [arg segment]]
[call [cmd distance_side]   [arg segment]]
[call [cmd distance_height] [arg segment]]
[call [cmd distance_depth]  [arg segment]]

In this form the commands take the names of a single segment and
compute it length, either the full euclidean distance between its
joints, or the length along the named axes.

[para] The following segments are known:

[list_begin definitions]
[def left-lower-arm]  left-hand   -- left-elbow
[def left-upper-arm]  left-elbow  -- left-shoulder
[def left-lower-leg]  left-foot   -- left-knee
[def left-upper-leg]  left-knee   -- left-hip
[def right-lower-arm] right-hand  -- right-elbow
[def right-upper-arm] right-elbow -- right-shoulder
[def right-lower-leg] right-foot  -- right-knee
[def right-upper-leg] right-knee  -- right-hip
[list_end]

[list_end][comment ==========================================Distances=]


[def {Undirected Axis Alignment}][list_begin definitions][comment =UAA=]

[call [cmd horizontal_side]  [arg jointa] [arg jointb]]
[call [cmd vertical]         [arg jointa] [arg jointb]]
[call [cmd horizontal_depth] [arg jointa] [arg jointb]]

[call [cmd horizontal_side]  [arg segment]]
[call [cmd vertical]         [arg segment]]
[call [cmd horizontal_depth] [arg segment]]

The commands take the names of two joints or of one segment (which
maps to two joints), determine their locations and then check if these
locations are aligned with the primary axes of the coordinate system.

[para] The result of the commands is a boolean value, [const true] if
the relationship holds, and [const false] otherwise.

[list_end][comment ================================================UAA=]

[def {Directed Axis Alignment}][list_begin definitions][comment ===DAA=]

[call [cmd horizontal_right]    [arg jointa] [arg jointb]]
[call [cmd horizontal_left]     [arg jointa] [arg jointb]]
[call [cmd vertical_up]         [arg jointa] [arg jointb]]
[call [cmd vertical_down]       [arg jointa] [arg jointb]]
[call [cmd horizontal_backward] [arg jointa] [arg jointb]]
[call [cmd horizontal_forward]  [arg jointa] [arg jointb]]

[call [cmd horizontal_right]    [arg segment]]
[call [cmd horizontal_left]     [arg segment]]
[call [cmd vertical_up]         [arg segment]]
[call [cmd vertical_down]       [arg segment]]
[call [cmd horizontal_backward] [arg segment]]
[call [cmd horizontal_forward]  [arg segment]]

The commands take the names of two joints or of one segment (which
maps to two joints), determine their locations and then check if these
locations are aligned with the primary axes of the coordinate system,
and in the described relationship.

[para] The result of the commands is a boolean value, [const true] if
the relationship holds, and [const false] otherwise.

[list_end][comment ================================================DAA=]

[def {General Spatial Relationships}][list_begin definitions][comment =GSR=]

[call [cmd right]  [arg jointa] [arg jointb]]
[call [cmd left]   [arg jointa] [arg jointb]]
[call [cmd above]  [arg jointa] [arg jointb]]
[call [cmd below]  [arg jointa] [arg jointb]]
[call [cmd before] [arg jointa] [arg jointb]]
[call [cmd behind] [arg jointa] [arg jointb]]

[call [cmd right]  [arg segment]]
[call [cmd left]   [arg segment]]
[call [cmd above]  [arg segment]]
[call [cmd below]  [arg segment]]
[call [cmd before] [arg segment]]
[call [cmd behind] [arg segment]]

The commands take the names of two joints or of one segment (which
maps to two joints), determine their locations and then check if these
locations are in the described relationship.

[para] The result of the commands is a boolean value, [const true] if
the relationship holds, and [const false] otherwise.

[list_end][comment ====================================================GSR=]

[def {Unit Conversion}][list_begin definitions][comment ================UC=]

[call [cmd mm]   [arg x]]
[call [cmd cm]   [arg x]]
[call [cmd inch] [arg x]]

These command convert floating point values from various units to
millimeters. The result of the commands are the conversion results.

[list_end][comment =====================================================UC=]
[list_end]


[subsection {Predefined Measurements}]

All instances of [class {::kinetcl stance}] know the following
measurements:

[list_begin definitions]
[def left-neck-length]		The distance from left soulder to neck.
[def left-upper-arm-length]	The distance from left shoulder to left elbow.
[def left-lower-arm-length]	The distance from left hand to left elbow.
[def right-neck-length]		The distance from right soulder to neck.
[def right-upper-arm-length]	The distance from right shoulder to right elbox.
[def right-lower-arm-length]	The distance from right hand to right elbow.
[def neck-length]		The minimum of both neck lengths above.
[def upper-arm-length]		The minimum of both upper arm lengths above.
[def lower-arm-length]		The minimum of both lower arm lengths above.
[list_end]

[subsection Examples]
