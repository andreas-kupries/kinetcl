# -*- tcl -*-
# KineTcl = A Tcl Binding for MS Kinect, based on the OpenNI framework
#
# (c) 2012 Andreas Kupries http://wiki.tcl.tk/andreas%20kupries
#

# # ## ### ##### ######## #############
## Requisites

package require critcl 3.1
critcl::buildrequirement {
    package require critcl::util 1
    package require critcl::class 1
}

# # ## ### ##### ######## #############

if {![critcl::compiling]} {
    error "Unable to build KineTcl, no proper compiler found."
}

# # ## ### ##### ######## #############
## Administrivia

critcl::license \
    {Andreas Kupries} \
    {Under a BSD license.}

critcl::summary \
    {OpenNI based Tcl binding to Kinect and similar sensor systems}

critcl::description {
    This package provides access to Kinect and similar sensor system,
    through binding to the OpenNI framework.
}

critcl::subject kinect primesense oenni nite game

# # ## ### ##### ######## #############
## Implementation.

critcl::tcl 8.5

# # ## ### ##### ######## #############
## Declarations and linkage of the OpenNI framework we are binding to.

critcl::cheaders   -I/usr/include/ni ; # XXX TODO automatic search/configuration
critcl::clibraries -lOpenNI

# # ## ### ##### ######## #############
## Declare the Tcl layer aggregating the C primitives / classes into
## useful commands and hierarchies.

critcl::tsources policy_depth.tcl    ; # -> map -> generator -> production
critcl::tsources policy_image.tcl    ; # -> map -> generator -> production
critcl::tsources policy_ir.tcl       ; # -> map -> generator -> production
critcl::tsources policy_gesture.tcl  ; # -> generator -> production
critcl::tsources policy_scene.tcl    ; # -> map -> generator -> production
critcl::tsources policy_user.tcl     ; # -> generator -> production
critcl::tsources policy_hands.tcl    ; # -> generator -> production
critcl::tsources policy_audio.tcl    ; # -> generator -> production
critcl::tsources policy_recorder.tcl ; # -> production
critcl::tsources policy_player.tcl   ; # -> production
critcl::tsources policy_script.tcl   ; # -> production
critcl::tsources policy.tcl

# # ## ### ##### ######## #############
## Main C section.

critcl::ccode {
    #include <XnOpenNI.h>

    /* The OpenNI context is generated on a per-interp basis
     * XXX TODO - This is suitable for encapsulation into a critcl utility package.
     * XXX NOTE - critcl::class uses the same template to manage the counter for
     *            auto-generated instance names.
     */

    typedef struct kinetcl_ctx {
	XnContext* context;
	Tcl_Obj* strNew;
	Tcl_Obj* strLost;
    } kinetcl_ctx;

    static void
    kinetcl_context_release (ClientData cd, Tcl_Interp* interp)
    {
	kinetcl_ctx* c = (kinetcl_ctx*) cd;

	xnContextRelease (c->context);
	Tcl_DecrRefCount (c->strNew);
	Tcl_DecrRefCount (c->strLost);
    }

    static kinetcl_ctx*
    kinetcl_context (Tcl_Interp* interp, XnStatus* status)
    {
#define KEY "KineTcl/OpenNI/Context"
	Tcl_InterpDeleteProc* proc = kinetcl_context_release;

	kinetcl_ctx* context = (kinetcl_ctx*) Tcl_GetAssocData (interp, KEY, &proc);
	if (!context) {
	    context = (kinetcl_ctx*) ckalloc (sizeof (kinetcl_ctx));

	    *status = xnInit (&context->context);
	    if (*status != XN_STATUS_OK) {
		ckfree ((char*) context);
		return NULL;
	    }
	    context->strNew  = Tcl_NewStringObj ("new",-1);
	    context->strLost = Tcl_NewStringObj ("lost",-1);
	    Tcl_SetAssocData (interp, KEY, proc, (ClientData) context);
	}

	return context;
#undef KEY
    }
}

# # ## ### ##### ######## #############
## C classes for the various types of objects.

critcl::source kt_depth.tcl    ; # -> map -> generator -> production
critcl::source kt_image.tcl    ; # -> map -> generator -> production
critcl::source kt_ir.tcl       ; # -> map -> generator -> production
critcl::source kt_gesture.tcl  ; # -> generator -> production
critcl::source kt_scene.tcl    ; # -> map -> generator -> production
critcl::source kt_user.tcl     ; # -> generator -> production
critcl::source kt_hands.tcl    ; # -> generator -> production
critcl::source kt_audio.tcl    ; # -> generator -> production
critcl::source kt_recorder.tcl ; # -> production
critcl::source kt_player.tcl   ; # -> production
critcl::source kt_script.tcl   ; # -> production

# # ## ### ##### ######## #############
## Make the C pieces ready. Immediate build of the binaries, no deferal.

if {![critcl::load]} {
    error "Building and loading KineTcl failed."
}

# # ## ### ##### ######## #############

package provide kinetcl 0
return

# vim: set sts=4 sw=4 tw=80 et ft=tcl:
