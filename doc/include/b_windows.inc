[subsection {Build & Installation (Windows)}]

This section describes the actions required to install KineTcl on Windows(tm)
systems.

If you have to install KineTcl on a Unix machine (Linux, BSD, and
related, including OS X) see section
[sectref {Build & Installation (Unix)}] instead.

[para] To install KineTcl simply run

[example {
    /path/to/tclsh8.5 /path/to/kettle -f /path/to/kinetcl/build.tcl install
}]

where [file /path/to/tclsh8.5] is the tclsh of your Tcl installation,
[file /path/to/kettle] is the installed [syscmd kettle] application,
and [file /path/to/kinetcl] the location of the KineTcl sources on your
system.

[comment { -- Check dependency on working directory!
	-- -- Can we do this inside and outside the kinetcl sources ?
}]

[para]

This builds all packages and then places them in a directory where the
[cmd tclsh8.5] will find them. 

[para] The above is written without assuming any associations from
extensions (like [file .tcl]) to executables responsible for the file
with that extension.

Actually, given that [file build.tcl] is technically a
[file kettle]-script, which in turn is a [file .tcl]-script I am not
sure if Windows is able to handle such a chain of interpreters.

The command given above simply spells out the entire chain.

[para]

The build system provides a small GUI for those not comfortable with
the command line.

This GUI is accessible by invoking [file build.tcl] without any
arguments from the command line.

[para]

To get help about the methods of [file build.tcl], and their complete
syntax, invoke [file build.tcl] with argument [method help], i.e.,
like

[example {
    /path/to/tclsh8.5 /path/to/kettle -f /path/to/kinetcl/build.tcl help
}]
