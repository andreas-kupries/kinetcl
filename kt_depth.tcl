
# # ## ### ##### ######## #############
## Depth Generator

critcl::class def ::kinetcl::Depth {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain depth generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateDepthGenerator (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############
    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
