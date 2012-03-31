The detail dictionary of this event contains:

[list_begin definitions]
[def [arg user]]
The numerical id of the user the event was generated for.

[def [arg status]]
The status of the calibration engine.

[para] The possible stati are
[list_begin enumerated]
[enum][const ok]
[enum][const no-user]
[enum][const arm]
[enum][const leg]
[enum][const head]
[enum][const torso]
[enum][const top-fov]
[enum][const side-fov]
[enum][const pose]
[enum][const manual-abort]
[enum][const manual-reset]
[enum][const timeout]
[list_end]
[list_end]
