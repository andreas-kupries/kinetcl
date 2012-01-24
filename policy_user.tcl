## -*- tcl -*-
# # ## ### ##### ######## #############

## This file defines a TclOO class 'user' wrapping around the C level
## class 'User' and its associated superclasses and aspects. The code
## here glues the C pieces together into a whole.

# # ## ### ##### ######## #############

package require TclOO

# # ## ### ##### ######## #############

oo::class create ::kinetcl::user {
    # XXX superclass ...

    # user -> generator -> production
    #      -> skeleton
    #      -> pose detection
    #      -> hand touching fov

    variable myuser ;# mygenerator myproduction

    constructor {} {
	set myuser [::kinetcl::User]
	# next [$myuser @handle] ; # Initialize superclass, same C handle.
	return
    }

    destructor {
	$myuser destroy
	return
    }

    # XXX How do I forward this class' instance methods to the myuser component ?
    # XXX At best automatically,without having to write a wrapper/forward for each
    # XXX method.

}

# # ## ### ##### ######## #############
