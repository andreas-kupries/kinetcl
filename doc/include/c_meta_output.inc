[def [const output]]
The value is a dictionary holding information about the output
produced by the node. The keys found in this dictionary, and the
associated values are:

[list_begin definitions][comment --output-meta-data--]
[def [const frame]]
The id of the current frame.

[def [const new]]
The [const isNew] flag of the current frame.

[def [const size]]
The size of the frame, in bytes. Together with the resolution of the
frame we can compute the number of bytes per pixel in the map.

[def [const time]]
The time-code of the current frame.

[list_end][comment ----------------output-meta-data--]
