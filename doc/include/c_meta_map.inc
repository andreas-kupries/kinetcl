[def [const map]]
The value is a dictionary holding information about the map produced
by the node. The keys found in this dictionary, and the associated
values are:

[list_begin definitions][comment --map-meta-data--]
[include c_enum_pixelformat.inc]

[def [const fps]]
The frame rate of the node, in frames per second.

[def [const fullres]]
The full resolution of the produced depth maps. The value is a
2-element list containing the horizontal and vertical resolution in
pixels, in this order.

[def [const offset]]

The location of the produced depth map within the full depth map. The
value is a 2-element list containing the horizontal and vertical
position in pixels, in this order.

This can differ from [const {{0 0}}] if and only if cropping is
active.

[include c_meta_output.inc]

[def [const res]]
The current resolution of the produced depth maps. This may be less
than the full resolution (see above), if cropping is active. The
value is a 2-element list containing the horizontal and vertical
resolution in pixels, in this order.

[list_end][comment ----------------map-meta-data--]
