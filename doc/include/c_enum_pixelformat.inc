[def [const format]]
The pixel format of the depth maps produced by the node.
The possible values are:

[list_begin definitions][comment --pixel-format-values--]
[def [const rgb24]]  3 bytes/pixel red/green/blue.
[def [const yuv422]] Lumincance/2-Chroma, chroma in reduced horizontal resolution.
[def [const grey8]]  1 byte/pixel, 256 grey levels.
[def [const grey16]] 2 byte/pixel, 65536 grey levels, depths, or labels.
[def [const mjpeg]]  Motion JPEG compressed image.
[list_end][comment -------------pixel-format-values--]

[para] The formats [const yuv422] and [const mjpeg] are not supported
by [package kinetcl].
