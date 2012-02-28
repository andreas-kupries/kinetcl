
# # ## ### ##### ######## #############
## Image Generator

critcl::class def ::kinetcl::Image {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain image generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateImageGenerator (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############
    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
