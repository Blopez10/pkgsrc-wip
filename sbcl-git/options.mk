
PKG_OPTIONS_VAR=	PKG_OPTIONS.sbcl

PKG_SUPPORTED_OPTIONS=	doc xref wtimer thruption safepoint threads zcore
PKG_SUGGESTED_OPTIONS=	doc threads

## TBD: 'source' option, to install the Lisp source code under
## share/sbcl/ or somesuch - thus allowing for it to be accessed for
## source review, independent of /usr/pkgsrc
## + update "SYS" paths in site-lisp

## TBD: options help for these esoteric build-option symbols

.include "../../mk/bsd.options.mk"

PLIST_VARS+=		doc

## --

.if !empty(PKG_OPTIONS:Mdoc)
##
## TBD: doc-pdf feature + texi2pdf or makeinfo --pdf
##
USE_TOOLS+=	makeinfo
PLIST.doc=	yes
.endif


## Advanced port build options for SBCL
##
## The following variables will affect SBCL_BUILD_OPTIONS:
##   SBCL_BUILD_WITH_OPTIONS
##   SBCL_BUILD_WITHOUT_OPTIONS


.if !empty(PKG_OPTIONS:Mxref)
SBCL_BUILD_WITH_OPTIONS+=	sb-xref-for-internals
.else
SBCL_BUILD_WITHOUT_OPTIONS+=	sb-xref-for-internals
.endif

## NB: Each of the following entails a dependency on the subsequent,
## when enabled in the build.
##
## This is implemented in reference to the SBCL source file,
## base-target-features.lisp-expr
##
##
## TBD - Parsing PKG_OPTIONS.sbcl in order to verify that the
## set of provided options will not conflict with the following
## configuration logic -- furthermore, emitting an error message,
## in case of conflicting options
##
## e.g +witmer -threads [untenable]
##

.if !empty(PKG_OPTIONS:Mwtimer)
. if empty(PKG_OPTIONS:Mthruption)
PKG_OPTIONS+=thruption
. endif
SBCL_BUILD_WITH_OPTIONS+=	sb-wtimer
.else
SBCL_BUILD_WITHOUT_OPTIONS+=	sb-wtimer
.endif


.if !empty(PKG_OPTIONS:Mthruption)
. if empty(PKG_OPTIONS:Msafepoint)
PKG_OPTIONS+=safepoint
. endif
SBCL_BUILD_WITH_OPTIONS+=	sb-thruption
.else
SBCL_BUILD_WITHOUT_OPTIONS+=	sb-thruption
.endif


.if !empty(PKG_OPTIONS:Msafepoint)
. if empty(PKG_OPTIONS:Mthreads)
PKG_OPTIONS+=threads
. endif
SBCL_BUILD_WITH_OPTIONS+=	sb-safepoint
.else
SBCL_BUILD_WITHOUT_OPTIONS+=	sb-safepoint
.endif


.if !empty(PKG_OPTIONS:Mthreads)
SBCL_BUILD_WITH_OPTIONS+=	sb-thread
.else
SBCL_BUILD_WITHOUT_OPTIONS+=	sb-thread
.endif


.if !empty(PKG_OPTIONS:Mzcore)
## TBD: May affect PLIST
SBCL_BUILD_WITH_OPTIONS+=	sb-core-compression
.include "../../devel/zlib/buildlink3.mk"
.else
SBCL_BUILD_WITHOUT_OPTIONS+=	sb-core-compression
.endif
