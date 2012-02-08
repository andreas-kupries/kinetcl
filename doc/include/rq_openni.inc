
[subsection {OpenNI / NITE}]

KineTcl is, despite its name, not a direct binding to the Kinect
itself. It actually is a binding to the more general OpenNI
framework. This framework provides a set of generic APIs for sensors,
processing algorithms, and applications into which anything following
these APIs can be plugged into.

[para] PrimeSense, the maker of the 3D sensor found in the Kinect is a
main member of the OpenNI organization managing the framework and
provides plugins for its sensor and various analysis algorithms.

[para] To build KineTcl the OpenNI binaries have to be
installed. These can be found in the downloads section of the OpenNI
website at [uri http://www.openni.org/].

[para] Development was done against OpenNI version 1.5.2.21. Note that
this version has a bug in its headers. To work around this bug the
headers have to be modified, preferably before installing them.

[para] Open the header file [file XnModuleInterface.h] in the editor
of your choice and look for the declaration of

[example {
     typedef struct XnModuleExportedProductionNodeInterface {
     	     ...
     } XnModuleExportedProductionNodeInterface;
}]

Rewrite the end of this declaration to

[example {
     typedef struct XnModuleExportedProductionNodeInterface {
     	     ...
     } ;
}]

This removes a conflict between this declaration and its forward
declaration in the header file [file XnTypes.h].

[para] When actually using a Kinect the OpenNI framework alone is not
useful. To talk to a Kinect we also have to install the binaries for
the PrimeSense Sensor inside of the device. These can also be found in
the downloads section of the OpenNI website. During development
PrimeSensor version 5.1.0.41 was installed.

[para] Furthermore it is recommended to install the PrimeSense NITE
binaries, which provide various higher-level analysis
algorithms. These are again found at the OpenNI website. During
development NITE version 1.5.2.23 was installed.

[para] For those wishing to understand things on a deeper level the
sources of OpenNI and of the sensor are available as well, through the
OpenNI website. Of course. The NITE package however seems to be
closed.
