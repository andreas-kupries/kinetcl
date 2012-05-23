
[subsection Sensors]

When actually using a Kinect the OpenNI framework alone is not enough.

[para] We have to install the drivers for our sensor device as well.

[para] Please note that the Sensor driver binaries available at
[uri http://www.openni.org/Downloads.aspx] are only generic to devices
using PrimeSense's sensor and are [emph not] adapted to specific
devices like MS Kinect. [emph {Do not install these}], but whatever is
available for your specific device.

[para] For MS Kinect the sources of the specific sensor driver are
found at [uri https://github.com/avin2/SensorKinect].

[para] This repository also contain prebuilt binaries for various
platforms, which were used during development of the binding. Should
you wish to build the sensor driver by yourself, please follow their
instructions on building the package.  If there are problems with
their directions please file a bug against the SensorKinect project,
and not KineTcl.

[para] Development was done against the binaries of SensorKinect
version 5.1.0.25. After downloading the binaries were installed by
unpacking the tarball and then running the provided installation
script. I.e.:

[example {
	 bunzip2 < SensorKinect091-Bin-Linux64-v5.1.0.25.tar.bz2 | tar xf -
	 cd SensorKinect091-Bin-Linux64-v5.1.0.25
	 sudo ./install.sh
	 # Note the sudo above, this script installs binaries into
	 # root owned directories.
}]

On a specific note, one of the files installed is
[file Install/55-primesense-usb.rules]
which is placed into [file /etc/udev/rules.d].

[para] This file contains the udev rules which enable access to the
usb sensor devices by non-root users.
