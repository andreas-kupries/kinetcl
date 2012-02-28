
# # ## ### ##### ######## #############
## Audio Generator

critcl::class def ::kinetcl::Audio {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain audio generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateAudioGenerator (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############
    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
