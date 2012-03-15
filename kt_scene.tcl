
# # ## ### ##### ######## #############
## Scene Analyzer

critcl::class def ::kinetcl::Scene {
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

    support {
	static Tcl_Obj*
	kinetcl_convert_scene_metadata (XnSceneMetaData* meta)
	{
	    Tcl_Obj* res = Tcl_NewDictObj ();

	    /* Only image specific information is pData, the raw bytes */
	    Tcl_DictObjPut (NULL, res,
			    Tcl_NewStringObj ("map",-1),
			    kinetcl_convert_map_metadata (meta->pMap));
	    return res;
	}
    }

    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## #############
