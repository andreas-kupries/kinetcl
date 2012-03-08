## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines helper commands used at build-time within the C
## code generation. These commands are not available at runtime, and
## shouldn't be. They are similar to the Publish and MixCapabilities
## commands in policy_base, providing setup of common constructions
## found in and shared by the C classes. (Common instance variables,
## their construction, etc.).

# # ## ### ##### ######## #############

critcl::source support_classes.tcl
critcl::source support_callbacks.tcl

# # ## ### ##### ######## #############
return
