
# # ## ### ##### ######## #############
## Recorder

critcl::class def kinetcl::Recorder {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain recorder object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateRecorder (instance->onicontext, NULL, &h);
    }

    # # ## ### ##### ######## #############
    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
