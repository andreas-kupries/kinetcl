
[comment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%]
[subsection {Hand Touching FOV Edge}]

Should an instance support the events for hands touching the edge of
the field of view the following methods become available.

This support can checked by invoking the inherited method
[method is-capable-of] for the capability name
[const hand-touching-fov-edge].

[include cevents.inc]

[comment ===============================================================]
[vset NAME fov-edge]
[vset EARGS fov]
[vset DESC {hands coming into contact with the edge of the field of view (a box)}]
[include callback.inc]
