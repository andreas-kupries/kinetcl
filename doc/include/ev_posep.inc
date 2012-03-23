[include ev_pose.inc]

[def [arg status]]
The status of the pose detection engine.

[para] The possible stati are
[list_begin enumerated]
[enum][const ok]
[enum][const no-user]
[enum][const top-fov]
[enum][const side-fov]
[enum][const error]
[enum][const no-tracking]
[list_end]
