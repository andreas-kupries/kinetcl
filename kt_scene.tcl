
# # ## ### ##### ######## #############
## Scene Analyzer

critcl::class def kinetcl::Scene {
    # # ## ### ##### ######## #############
    ::kt_node_class {
	/* Create a plain scene analyzer object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */

	s = xnCreateSceneAnalyzer (instance->onicontext, &h, NULL, NULL);
    }

    # # ## ### ##### ######## #############
    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
