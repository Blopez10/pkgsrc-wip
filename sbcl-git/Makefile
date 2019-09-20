# $NetBSD: Makefile,v 1.43 2014/10/09 14:06:30 thomasklausner Exp $

DISTNAME=		sbcl-source-${SBCL_PATCHVERSION}
PKGNAME=		${DISTNAME:S/-source//}
CATEGORIES=		lang

MAINTAINER=		asau@users.sourceforge.net
HOMEPAGE=		http://www.sbcl.org/
COMMENT=		SBCL, a Common Lisp implementation

GIT_REPOSITORIES=	sbcl
GIT_REPO.sbcl=		git://git.code.sf.net/p/sbcl/sbcl

## NB: Some of the annotations in this source file may be moved to the
## file files/README.pkg.md

## SBCL_PATCHVERSION
##
## Usage:
## - Allow for version-oriented disptaching on DISTNAME in mk.conf
## - Set a checkpoint for port maintanence @ new upstream versions,
##   there in reference to the post-configure tgt defined below.
##
## Maintenance Advice:
## - This should be kept in sync with the patchlevel version
##   as defined in version.lisp-expr, such that the latter file is
##   produced with the SBCL shell script, generate-version.sh. The
##   latter script operates on Git tags, as defined in the local
##   source repository - presumably, in mirror to upstream tags.
##
## Effects:
## - If the patchlevel version set in version.lisp-expr does not match
##   this version, the build will fail with notification during
##   configure. This should serve to prevent any unwanted divergence
##   between the version in DISTNAME and the version as distributed.
##
## Notes:
## - There is a further description provided about this value's expected
##   usage, below.
##
SBCL_PATCHVERSION=	1.5.6

.include "../../mk/bsd.prefs.mk"
.include "../../wip/mk/git-package.mk"


.if exists(${WRKDIR}/.pkgdb/+CONTENTS)
## Unparse and reuse the previous PKGREVISION
##
## This should serve to ensure that some interrupted 'make install'
## can be resumed, assuming that the +CONTENTS file has been created by
## the time when the 'make install' failed or was interrupted. If not,
## the build should be cleaned before restarting, or the original
## PKGREVISION specified on the cmdline.
##
## FIXME: Save the PKGREVISION at the start of the build, using a unique
## cookie filename uner WRKDIR
##
## NB: This script in itself may not be able to use PKG_DB_TMPDIR for
## purposes of pathname reference. That variable is typically set within
## pkgsrc mk/pkgformat/pkg/metadata.mk and may not have been set, when
## this expression is evaluated as a shell script. It's assumed here
## that that value will not have been changed to any other value, within
## any site mk-file expressions.
##
_SB_REUSE_PKGREV_CMD=${GREP} '^@name' ${WRKDIR}/.pkgdb/+CONTENTS | \
	${AWK} '{print $$2}' | ${SED} 's|^${PKGNAME_NOREV}${NBPAX_PROGRAM_PREFIX}||'
PKGREVISION=${_SB_REUSE_PKGREV_CMD:sh}
.else
## Use a finer resolution for the date-oriented PKGREVISION string,
## such that the PKGREVISION will differ across any two pkg builds
## within a day's duration (UTC) and will be monotonically increasing,
## between any earlier build and any later - assuming that both builds
## were not begun within the same minute, on the system clock.
##
## This should serve to ensure that two builds for different upstream
## changesets, on the same day, will not be built under the same PKGNAME,
## while not requiring access to the source repository, if in order to
## produce the initial PKGREVISION string.
_GIT_PKGVERSION_CMD:=	${DATE} -u +'%Y.%m.%dT%H%M'
.endif

USE_TOOLS+=		gmake gtar:run patch

WRKSRC=			${WRKDIR}/${GIT_EXTRACTDIR.sbcl}

#
# Bootstrap section.
#
# SBCL needs an existing Common Lisp system to build it...
# Currently allowed systems are CLISP, CMUCL, OpenMCL, and SBCL itself.
#
#  If SBCL is installed in an unusual place when trying to build this
#  package, you may need to set the full path in SBCL_BOOT_SYSTEM and
#  build the package with "SBCL_HOME=/path/to/SBCL/core/image/ make"

#SBCL_BOOT_SYSTEM=	clisp			# CLisp
#SBCL_BOOT_SYSTEM=	"lisp -batch"		# CMUCL
#SBCL_BOOT_SYSTEM=	"openmcl --batch"	# OpenMCL
#SBCL_BOOT_SYSTEM=	sbcl			# SBCL

.if !defined(SBCL_BOOT_SYSTEM)
# Use "clisp -ansi -on-error abort" to make the build more reproducible,
# per Christophe Rhodes:
SBCL_BOOT_SYSTEM=	clisp -norc -ansi -on-error abort
BUILD_DEPENDS+=		clisp-[0-9]*:../../lang/clisp
UNLIMIT_RESOURCES=	datasize
.elif ${SBCL_BOOT_SYSTEM} == clisp
BUILD_DEPENDS+=		clisp-[0-9]*:../../lang/clisp
UNLIMIT_RESOURCES=	datasize
.elif ${SBCL_BOOT_SYSTEM} == sbcl
# Get bootstrap version:
BUILD_DEPENDS+=		sbcl-[0-9]*:../../lang/sbcl
.endif

SUBST_CLASSES+=			fix-paths
SUBST_STAGE.fix-paths=		pre-configure
SUBST_MESSAGE.fix-paths=	Fixing absolute paths.
SUBST_FILES.fix-paths=		doc/sbcl.1 doc/manual/intro.texinfo doc/manual/start-stop.texinfo
SUBST_VARS.fix-paths=		PREFIX
#SUBST_SED.fix-paths+=		-e 's,/var/log,${VARBASE}/log,g'

SUBST_CLASSES+=			trim-version
SUBST_STAGE.trim-version=	post-configure
SUBST_MESSAGE.trim-version=	Clean up version.lisp-expr
SUBST_FILES.trim-version=	version.lisp-expr
SUBST_SED.trim-version=		-e 's,-dirty",",'


.if !empty(OPSYS:MNetBSD)
## NB: This patch will probably fail w/ the current SBCL src.
##
## The newer asdf-module.mk system, now used in sb-prof, may need to be
## tested for the affected test tgt, on a NetBSD system. Ideally,
## the asdf-module.mk src may not need a patch for the build
_PKGSRC_PATCHES+= ${PATCHDIR}/nb-patch-revert-37d3828773e2f847bb1ed7522b0af4fb8e736fc8
.endif

.include "options.mk"

.for OPT in ${SBCL_BUILD_WITH_OPTIONS}
SBCL_BUILD_OPTIONS+=	--with-${OPT}
.endfor

.for OPT in ${SBCL_BUILD_WITHOUT_OPTIONS}
SBCL_BUILD_OPTIONS+=	--without-${OPT}
.endfor

.if !empty(PKG_OPTIONS:Mdoc)
INFOFILES+=		${WRKSRC}/doc/manual/*.info ${WRKSRC}/doc/manual/*.info-[1-9]*
INFOFILES+=		${WRKSRC}/doc/internals/*.info ${WRKSRC}/doc/internals/*.info-[1-9]*
## PERL and graphviz (dot) will be needed for 'make info' in doc/internals/
USE_TOOLS+=		perl
TOOL_DEPENDS+=		graphviz-[0-9]*:../../graphics/graphviz

do-docs-build: .PHONY ## NB: needs 'build' as an implicit prereq
	${GMAKE} -C ${WRKSRC}/doc/manual/ info MAKEINFO=${MAKEINFO}
	${GMAKE} -C ${WRKSRC}/doc/internals/ info MAKEINFO=${MAKEINFO}
.else
do-docs-build: .PHONY
.endif

## NB - A synopsis for the following
##
## In pre-configure:
## - Patch make-config.sh to not re-run generate-version.sh
##   when the file version.lisp-expr exists
##
## Then, in do-configure:
## - Run generate-version.sh once (via make-config.sh)
##
## Subsequently, in post-configure:
## - Trim the '-dirty' flag from version.lisp-expr, using subst classes.
##   Assuming that the patches applied in this port will not modify
##   any souce files under SBCL 'src', the '-dirty' flag may appear
##   misleading, for some purposes of systems review.
##
## - Verify corresondance between the version in the locally available
##   source repository and SBCL_PATCHVERSION, or fail with error.
##   The error message would indicate any version-mismatch. In case of
##   version mistmatch, this port should be updated, in at least to
##   provide a 'Version bump' at SBCL_PATCHVERSION
##
## This endeavors to work around the dependency issues that would be
## introduced, in either of two alternate approaches for the versioning
## of this pkg:
##
## 1. If we'd try to produce a package version number from the SBCL
##    build file, version.lisp-expr, or
## 2. If we'd try to produce a package version number more directly
##    derived from the Git repository information, itself. Such
##    information may not be immediately available in the pkgsrc ports
##    system, at some times of when the pkg build is begun.
##
## In either instance, the resulting derived version may not match
## that which would have been derived before the corresponding stage in
## the build process - respectively, as in regards to the 'configure'
## and earlier 'extract' stages, in the build.
##
## If this approach to versioning may not be sufficient for all
## applications, perhaps it may be feasible to store a persistent version
## number under ./files/ such that the version number would have been
## derived directly from the Git source repository for SBCL - in a
## manner no doubt analogous to the behaviros of SBCL's build script,
## generate-version.sh
##
## For support of any specifically tagged release of SBCL, GIT_TAG.sbcl
## may be defined locally in mk.conf
##
## ----
##
## About versioning in this pkg:
##
## - The PKGREVISION string will be derived as representative of a
##   timestamp at which the build was begun. If CHECKOUT_DATE.sbcl
##   was defined in the build, alternately, the PKGREVISION would
##   reflect that timestamp.
##
## - The version number in PKGNAME - in effect, the concatenation of
##   PKGVERSION_NOREV, the 'nb' qualifier, and the PKGREVISION string -
##   this version number will include, as a substring, the value of
##   SBCL_PATCHVERSION. This, of course, may not match the value
##   returned by lisp-implementation-version when evaluated in the
##   resutling SBCL build, It will provide a monotonicaly increasing
##   package version, for subsequent package builds - assuming a
##   duration of at least one minute, between subsequent package builds.
##
## - The version number PKGNAME_NOREV will be derived from the
##   SBCL_PATCHVERSION for the build. As such, the expression
##       ${PKGVERSION_NOREV} == ${SBCL_PATCHVERSION}
##   typically evalutes as true.
##
## - The version number SBCL_PATCHVERSION will provide a consistent
##   version number, across a certain series of changesets, by in large
##   independent of the Git repository or the build system. This version
##   can be considered to apply to the port from which the pkg is built.
##
## - The version number returned by the function lisp-implementation-version,
##   when evaluated in the resulting SBCL build, may be considered to represent
##   the normative version identifier for that SBCL distribution. It
##   should match SBCL_PATCHVERSION in the complete substring
##   represented as the value of the latter.

do-configure:
	cd ${WRKSRC} && ${PKGSRC_SETENV} CC=${CC} GNUMAKE=${GMAKE} ${SH} \
	  make-config.sh --prefix=${PREFIX} --xc-host=${SBCL_BOOT_SYSTEM:Q} ${SBCL_BUILD_OPTIONS}

post-configure:
	@SRC_VERSION=$$(${TAIL} -n1 ${WRKSRC}/version.lisp-expr); \
		VERSION=$$( ${ECHO} "$${SRC_VERSION}" | \
		${SED} -e 's@"\([1-9][0-9]*\.[1-9][0-9]*\.[1-9][0-9]*\).*"@\1@g;' ); \
	  if [ "$${VERSION}" != "${SBCL_PATCHVERSION}" ]; then \
	    echo "#-- ${PKGPATH}: Version Mismatch: Source patchlevel version $${VERSION} of $${SRC_VERSION} does not match ${SBCL_PATCHVERSION}" 1>&2; \
	    echo "#-- ${PKGPATH}: Please update SBCL_PATCHVERSION" 1>&2; \
	    exit 1; \
          else echo "#-- ${PKGPATH}: Build for source version $${SRC_VERSION}"; \
	  fi

## Primary Build, Install, Test

do-build:
	cd ${WRKSRC} && ${PKGSRC_SETENV} CC=${CC} GNUMAKE=${GMAKE} ${SH} make.sh
post-build: do-docs-build
	cd ${WRKSRC} && ${RM} -f contrib/sb-cover/test-output/*

do-install:
	cd ${WRKSRC} && BUILD_ROOT=${DESTDIR} INSTALL_ROOT=${PREFIX} MAN_DIR=${PREFIX}/${PKGMANDIR} ${SH} install.sh
	${TEST} -f ${WRKSRC}/doc/internals/sbcl-internals.info && \
		${INSTALL} ${COPY} -o ${DOCOWN} -g ${DOCGRP} -m ${DOCMODE} \
		${WRKSRC}/doc/internals/sbcl-internals.info ${DESTDIR}${PREFIX}/share/info/
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/asdf-install/installer.lisp.orig
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/sb-posix/posix-tests.lisp.orig
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/sb-posix/test-output/write-test.txt
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/sb-posix/test-output/read-test.txt
	rm -f ${DESTDIR}${PREFIX}/bin/sbcl.old ${DESTDIR}${PREFIX}/lib/sbcl/sbcl.core.old
	rm -f ${DESTDIR}${PREFIX}/share/info/dir
	find ${DESTDIR}${PREFIX}/lib/sbcl -type d -name CVS -exec rm -rf {} \+
	find ${DESTDIR}${PREFIX}/lib/sbcl -type f -name .cvsignore -exec rm -f {} \+

do-test:
	cd ${WRKSRC}/tests && ${SH} ./run-tests.sh

.if ${MACHINE_ARCH} == "x86_64"
PLIST_SUBST+=	SUFX64=-64
.else
PLIST_SUBST+=	SUFX64=
.endif

.include "../../mk/bsd.pkg.mk"
