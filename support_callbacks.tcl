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

fprintf (stdout,"CB... %d (%s)\n", pthread_self(), Tcl_GetString(cmd));fflush(stdout);

	Tcl_IncrRefCount (cmd);
	Tcl_Preserve (interp);
	saved = Tcl_SaveInterpState (interp, TCL_OK);

fprintf (stdout,"Cmd/ %d\n",cmd->refCount);fflush(stdout);

	res = Tcl_GlobalEvalObj (interp, cmd);

fprintf (stdout,"Cmd\\ %d\n",cmd->refCount);fflush(stdout);

	Tcl_RestoreInterpState (interp, saved);
	Tcl_Release (interp);
	Tcl_DecrRefCount (cmd);

fprintf (stdout,"...Done/CB\n");fflush(stdout);
    }
}

# # ## ### ##### ######## #############

critcl::source support_callbacks1.tcl
critcl::source support_callbacks2.tcl
critcl::source support_callbacks3.tcl

# # ## ### ##### ######## #############
return
