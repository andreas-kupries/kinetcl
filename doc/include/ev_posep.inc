The detail dictionary of this event contains:

[list_begin definitions]
[def [arg pose]]
The name of the pose the event was generated for.

[def [arg user]]
The numerical id of the user the event was generated for.

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
[list_end]
