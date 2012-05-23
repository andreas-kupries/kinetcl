
[subsection CriTcl]

To build both [sectref Crimp], and KineTcl the tool [syscmd critcl] is
required.

[para] Both Crimp's and KineTcl's build systems accept it either as an
application found in the PATH, or as a Tcl package available to the
[syscmd tclsh] used to run their build & installation processes.

[para] While [sectref Crimp] just requires version 3 or higher KineTcl
itself [emph must] have version 3.1, which is currently not released
yet and only found in CriTcl's github repository.

[para] This github repository can be found at
[uri http://jcw.github.com/critcl].

[para] The relevant repository branch is [emph dev31].
Do not try to use the master branch.

[para] Please make sure to use at least commit [lb]fe814d4977[rb], or
later.

[para] At the above url is also an explanation on how to build and
install CriTcl, including a list of its dependencies.

[para] Its instructions will not be repeated here. If there are
problems with their directions please file a bug against the critcl
project, and not KineTcl.

[para] Please note that the starkit and starpack provided at the site
are [emph not] useable, as they provide only critcl v3, not 3.1.
