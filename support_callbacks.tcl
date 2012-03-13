## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base.

## Here we define how callbacks are handled and exposed to users.

# # ## ### ##### ######## #############

critcl::ccode {
#include <pthread.h>
    static void
    kinetcl_invoke_callback (Tcl_Interp* interp, Tcl_Obj* cmd)
    {
	int res;
	Tcl_InterpState saved;

	Tcl_IncrRefCount (cmd);
	Tcl_Preserve (interp);
	saved = Tcl_SaveInterpState (interp, TCL_OK);

	res = Tcl_GlobalEvalObj (interp, cmd);

	if (res != TCL_OK) {
	    Tcl_BackgroundError (interp);
	}

	Tcl_RestoreInterpState (interp, saved);
	Tcl_Release (interp);
	Tcl_DecrRefCount (cmd);
    }
}

# # ## ### ##### ######## #############

critcl::source support_cbhandlers.tcl
critcl::source support_callbacks1.tcl
critcl::source support_callbacks2.tcl
critcl::source support_callbacks3.tcl

# # ## ### ##### ######## #############
return
