## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we define the processing of callbacks going from the raw
## OpenNI call to associated Tcl handler command.

# # ## ### ##### ######## #############

proc kt_cbhandler {group name cname signature body} {
    set signature [join [list {XnNodeHandle h} {*}$signature {void* clientData}] {, }]

    lappend map @@group@@     $group
    lappend map @@cname@@     $cname
    lappend map @@name@@      $name
    lappend map @@signature@@ $signature
    lappend map @@body@@      $body

    uplevel 1 [string map $map {
	# This code is fully run only once. At the second time the
	# duplicate field will error out, and the catch simply lets us
	# proceed, knowing, implicitly, that we field and mgmt is present.
	catch {
	    field Tcl_Interp* interp {Interpreter for the callback handlers}
	    constructor {
		instance->interp = interp;
	    }
	    destructor {
		/* instance->interp is a non-owned copy, nothing to do */
	    }
	}

	field Tcl_Obj* command@@cname@@ \
	    {Command prefix for '@@name@@' events (@@group@@ aspect)}

	support {
	    static void
	    @stem@_callback_@@cname@@_handler (@@signature@@)
	    {
		Tcl_Obj* cmd;
		Tcl_Obj* self;
		@instancetype@ instance = (@instancetype@) clientData;
		Tcl_Interp* interp = instance->interp;
		/* ASSERT (h == instance->handle) ? */

		/* Ignore event '@@name@@' if no handler set */
		if (!instance->command@@cname@@) return;

fprintf (stdout,"%u @ %s = (%p) [%p] @@cname@@\n", pthread_self(), Tcl_GetString (instance->self), instance, h);fflush(stdout);
return;

		self = Tcl_NewObj ();
		Tcl_GetCommandFullName (interp, instance->cmd, self);

		cmd = Tcl_DuplicateObj (instance->command@@cname@@);
		Tcl_ListObjAppendElement (interp, cmd, self);
		Tcl_ListObjAppendElement (interp, cmd, Tcl_NewStringObj ("@@name@@", -1));

		{ @@body@@ }

		/* Invoke "{*}$cmdprefix $self @@name@@ ..." */
		kinetcl_invoke_callback (interp, cmd);
	    }
	}
    }]
}

# # ## ### ##### ######## #############
return
