
[subsection {OpenNI}]

KineTcl is, despite its name, not a direct binding to the Kinect
itself. It actually is a binding to the more general OpenNI
framework. This framework provides a set of generic APIs for sensors,
processing algorithms, and applications into which anything following
these APIs can be plugged into.

[para] PrimeSense, the maker of the 3D sensor found in the Kinect is a
main member of the OpenNI organization managing the framework and
provides plugins for its sensor and various analysis algorithms.


[para] The OpenNI binaries must be installed to build and use KineTcl.

[para] These binaries can be found at
[uri http://www.openni.org/Downloads/OpenNIModules.aspx]

[para] References to the sources of the frameork, should you wish to
build them by yourself, can be found at
[uri http://www.openni.org/Downloads.aspx]. When doing so please
follow their instructions on building the package.  If there are
problems with their directions please file a bug against the OpenNI
project, and not KineTcl.

[para] Development was done against the binaries of OpenNI version
1.5.2.23. After downloading the binaries were installed by unpacking
the tarball and then running the provided installation script. I.e.:

[example {
	 bunzip2 < openni-bin-dev-linux-x64-v1.5.2.23.tar.bz2 | tar xf -
	 cd OpenNI-Bin-Dev-Linux-x64-v1.5.2.23
	 # !Edit the headers to work around the bug mentioned below.
	 sudo ./install.sh
	 # Note the sudo above, this script installs binaries into
	 # root owned directories.
}]

[para] Note that version 1.5.2.23 has a bug in its headers.

To work around this bug the provided header files have to be modified,
[emph before] installing them.

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
