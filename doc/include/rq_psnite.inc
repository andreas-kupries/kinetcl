
[subsection NITE]

[para] OpenNI (the organization) recommends to install the PrimeSense
NITE binaries, which provide various higher-level analysis
algorithms.

[para] These binaries can be found at
[uri http://www.openni.org/Downloads/OpenNIModules.aspx]

[para] In contrast to the OpenNI framework itself NITE seems to be
closed-source, and no references to a source repository are available.

[para] During development NITE version 1.5.2.21 was installed.
After downloading the binaries were installed by unpacking the
tarball and then running the provided installation script. I.e.:

[example {
	 bunzip2 < nite-bin-linux-x64-v1.5.2.21.tar.bz2 | tar xf -
	 cd NITE-Bin-Dev-Linux-x64-v1.5.2.21
	 sudo ./install.sh
	 # Note the sudo above, this script installs binaries into
	 # root owned directories.
}]
