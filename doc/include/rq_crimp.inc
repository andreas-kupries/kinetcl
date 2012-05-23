
[subsection Crimp]

To build and use KineTcl the image processing package [package crimp]
is required.

[para] This package must be available to the [syscmd tclsh] used to
run KineTcl's build & installation process, and the [syscmd tclsh]
used to run scripts requiring KineTcl.

[para] KineTcl [emph must] have access to revision [lb]795374375f[rb]
of Crimp fossil reository, or later. Earlier revisions do not provide
all the operations used by KineTcl.

[para] This fossil repository can be found at
[uri http://chiselapp.com/user/andreas_kupries/repository/crimp/home].

[para] The relevant repository branch is [emph trunk].

[para] Crimp has a build and installation guide much like this one for
KineTcl, which can be found at the above site and explains how to
retrieve its sources and build the package, which dependencies are
required, etc. The direct link to this guide is
[uri http://chiselapp.com/user/andreas_kupries/repository/crimp/doc/tip/embedded/www/doc/files/crimp_installer.html]

[para] Its instructions will not be repeated here. If there are
problems with their directions please file a bug against the crimp
project, and not KineTcl.
