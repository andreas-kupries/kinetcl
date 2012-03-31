The detail dictionary of this event contains:

[list_begin definitions]
[def [arg hand]]
The numerical id of the hand the event was generated for.

[def [arg position]]
The position of the hand when it touched the edge. This is a 3-element
list of floating point values containing the [term {real world}]
x-, y-, and z-coordinates of the position, in this order.

[def [arg times]]
The timestamp is a floating point value in seconds.

[def [arg direction]]
The direction is one of
[list_begin enumerated]
[enum] [const illegal]
[enum] [const left]
[enum] [const right]
[enum] [const up]
[enum] [const down]
[enum] [const forward]
[enum] [const backward]
[list_end]
[list_end]
