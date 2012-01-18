# -*- tcl -*-
# KineTcl = A Tcl Binding for MS Kinect, based on the OpenNI framework
#
# (c) 2012 Andreas Kupries http://wiki.tcl.tk/andreas%20kupries
#

# # ## ### ##### ######## #############
## Requisites

package require critcl 3.1
critcl::buildrequirement {
    package require critcl::util 1
    package require critcl::class 1
}

# # ## ### ##### ######## #############

if {![critcl::compiling]} {
    error "Unable to build KineTcl, no proper compiler found."
}

# # ## ### ##### ######## #############
## Administrivia

critcl::license \
    {Andreas Kupries} \
    {Under a BSD license.}

critcl::summary \
    {OpenNI based Tcl binding to Kinect and similar sensor systems}

critcl::description {
    This package provides access to Kinect and similar sensor system,
    through binding to the OpenNI framework.
}

critcl::subject kinect primesense oenni nite game

# # ## ### ##### ######## #############
## Implementation.

critcl::tcl 8.5

# # ## ### ##### ######## #############
## Declarations and linkage of the OpenNI framework we are binding to.

critcl::cheaders   -I/usr/include/ni ; # XXX TODO automatic search/configuration
critcl::clibraries -lOpenNI

# # ## ### ##### ######## #############
## Declare the Tcl layer aggregating the C primitives into useful
## commands.

critcl::tsources policy.tcl

# # ## ### ##### ######## #############
## Main C section.

critcl::ccode {
    #include <XnOpenNI.h>

    /* The OpenNI context is generated on a per-interp basis
     * XXX TODO - This is suitable for encapsulation into a critcl utility package.
     * XXX NOTE - critcl::class uses the same template to manage the counter for
     *            auto-generated instance names.
     */

    static void
    kinetcl_context_release (ClientData cd, Tcl_Interp* interp)
    {
	xnContextRelease ((XnContext*) cd);
    }

    static XnContext*
    kinetcl_context (Tcl_Interp* interp, XnStatus* status)
    {
#define KEY "KineTcl/OpenNI/Context"
	Tcl_InterpDeleteProc* proc = kinetcl_context_release;
	XnContext* context = (XnContext*) Tcl_GetAssocData (interp, KEY, &proc);

	if (!context) {
	    *status = xnInit (&context);
	    if (*status != XN_STATUS_OK) {
		return NULL;
	    }
	    Tcl_SetAssocData (interp, KEY, proc, (ClientData) context);
	}

	return context;
#undef KEY
    }
}

# # ## ### ##### ######## #############
## Classes for the various types of objects.

# # ## ### ##### ######## #############
## Depth Generator

critcl::class def kinetcl::depth {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI depth generator object}

    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnContext*   c; /* The package's OpenNI context, per-interp global */
	XnNodeHandle h; /* The depth generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain depth generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */
	s = xnCreateDepthGenerator (c, &h, NULL, NULL);

	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}

# # ## ### ##### ######## #############
## Image Generator

critcl::class def kinetcl::image {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI image generator object}

    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnContext*   c; /* The package's OpenNI context, per-interp global */
	XnNodeHandle h; /* The image generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain image generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */
	s = xnCreateImageGenerator (c, &h, NULL, NULL);

	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}

# # ## ### ##### ######## #############
## IR (image) Generator

critcl::class def kinetcl::ir {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI IR generator object}

    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnContext*   c; /* The package's OpenNI context, per-interp global */
	XnNodeHandle h; /* The IR generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain ir generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */
	s = xnCreateIRGenerator (c, &h, NULL, NULL);

	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}

# # ## ### ##### ######## #############
## Gesture Generator

critcl::class def kinetcl::gesture {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI gesture generator object}

    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnContext*   c; /* The package's OpenNI context, per-interp global */
	XnNodeHandle h; /* The gesture generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain gesture generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */
	s = xnCreateGestureGenerator (c, &h, NULL, NULL);

	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}

# # ## ### ##### ######## #############
## Scene Analyzer

critcl::class def kinetcl::scene {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI scene analyzer object}

    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnContext*   c; /* The package's OpenNI context, per-interp global */
	XnNodeHandle h; /* The scene analyzer's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain scene analyzer object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */
	s = xnCreateSceneAnalyzer (c, &h, NULL, NULL);

	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}

# # ## ### ##### ######## #############
## User Generator

critcl::class def kinetcl::user {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI user tracker object}

    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnContext*   c; /* The package's OpenNI context, per-interp global */
	XnNodeHandle h; /* The user tracker's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain user generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */
	s = xnCreateUserGenerator (c, &h, NULL, NULL);

	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}

# # ## ### ##### ######## #############
## Hands Generator

critcl::class def kinetcl::hands {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI hands generator object}

    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnContext*   c; /* The package's OpenNI context, per-interp global */
	XnNodeHandle h; /* The hands generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain hands generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */
	s = xnCreateHandsGenerator (c, &h, NULL, NULL);

	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}

# # ## ### ##### ######## #############
## Audio Generator

critcl::class def kinetcl::audio {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI audio generator object}

    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnContext*   c; /* The package's OpenNI context, per-interp global */
	XnNodeHandle h; /* The audio generator's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain audio generator object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */
	s = xnCreateAudioGenerator (c, &h, NULL, NULL);

	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}

# # ## ### ##### ######## #############
## Recorder

critcl::class def kinetcl::recorder {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI recorder object}

    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnContext*   c; /* The package's OpenNI context, per-interp global */
	XnNodeHandle h; /* The recorder's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain recorder object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */
	s = xnCreateRecorder (c, NULL, &h);

	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}

# # ## ### ##### ######## #############
## Player

critcl::class def kinetcl::player {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI player object}

    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnContext*   c; /* The package's OpenNI context, per-interp global */
	XnNodeHandle h; /* The player's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain player object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */
	s = xnCreatePlayer (c, "oni", &h);

	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}

# # ## ### ##### ######## #############
## Script

critcl::class def kinetcl::script {
    include XnOpenNI.h

    field XnNodeHandle handle {Our handle of the OpenNI script object}

    constructor {
	XnStatus     s; /* Status of various OpenNI operations */
	XnContext*   c; /* The package's OpenNI context, per-interp global */
	XnNodeHandle h; /* The script's object handle */

	/* Get the framework context. Might fail. */
	c = kinetcl_context (interp, &s);
	if (!c) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Create a plain script object
	 * XXX TODO - Restrictions on creation via query object
	 * XXX TODO - Conversion of enumeration errors
	 */
	s = xnCreateScriptNode (c, NULL, &h); // XXX TODO: Which script formats exist ?

	if (s != XN_STATUS_OK) {
	    Tcl_AppendResult (interp, xnGetStatusString (s), NULL);
	    goto error;
	}

	/* Fill our structure */
	instance->handle  = h;
    }

    destructor {
	xnProductionNodeRelease (instance->handle);
    }
}

# # ## ### ##### ######## #############
## Make the C pieces ready. Immediate build of the binaries, no deferal.

if {![critcl::load]} {
    error "Building and loading KineTcl failed."
}

# # ## ### ##### ######## #############

package provide kinetcl 0
return

# vim: set sts=4 sw=4 tw=80 et ft=tcl:
