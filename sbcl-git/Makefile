# $NetBSD: Makefile,v 1.43 2014/10/09 14:06:30 thomasklausner Exp $

DISTNAME=		sbcl-source-${SBCL_PATCHVERSION}
PKGNAME=		${DISTNAME:S/-source//}
CATEGORIES=		lang

MAINTAINER=		asau@users.sourceforge.net
HOMEPAGE=		http://www.sbcl.org/
COMMENT=		SBCL, a Common Lisp implementation

GIT_REPOSITORIES=	sbcl
GIT_REPO.sbcl=		git://git.code.sf.net/p/sbcl/sbcl
#GIT_REVISION.sbcl=	# Unset

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
## - The version provided in PKGNAME is now being automatically updated
##   as per git-package.mk, such that presently derives a package
##   version number from the latest changeset date. Thus, any subsequent
##   builds of this package - aross any upstream source updates - should
##   be produced with a monotonically increasing package name, as
##   presently.
##
## - This does not entail any process for computing any mk-file
##   variables directly from version.lisp-expr - a build system file,
##   such that will not be available until after the configure tgt,
##   defined below.
##
SBCL_PATCHVERSION=	1.5.6

.include "../../mk/bsd.prefs.mk"
.include "../../mk/git-package.mk"

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
SBCL_BUILD_DOCS=	true
INFOFILES+=		${WRKSRC}/doc/manual/*.info ${WRKSRC}/doc/manual/*.info-*

do-remove-info-dir: .PHONY
	rm -f ${DESTDIR}${PREFIX}/share/info/dir
.else
do-remove-info-dir: .PHONY
.endif

## NB - also in pre-confgure
## - Patch make-config.sh to not re-run generate-version.sh
##   when version.lisp-expr exists
##
## Then, in do-configure
## - Run generate-version.sh (via make-config.sh)
##
## Subsq, in post-configure
## - Trim the '-dirty' flag from version.lisp-expr - using subst classes -
##   assuming the patches do not modify anything under SBCL 'src'
## - Verify corresondance between SBCL_PATCHVERSION, or fail with error.
##   The error message would indicate any version-mismatch. In case of
##   version mistmatch, this Makefile should be updated (please see above)
##
## This endeavors to work around the dependency circle introduced if we'd
## try to produce a package version number from SBCL version.lisp-expr.
##
## At present, the version number in PKGNAME will be derived from the
## latest changeset in the local git repository - whereas the version
## number in DISTNAME will provide a consistent version number across a
## certain series of changesets, by in large independent to the Git
## repository itself.

## NB: make-config.sh is now being run twice, once during
## configure, and once when it's run by make.sh during build.
##
## Should this prove to be a concern, SBCL make.sh may be patched
## to not re-run make-config.sh when the respective build configuration
## files have already been produced by an earlier make-config.sh [FIXME]

do-configure:
	cd ${WRKSRC} && env CC=${CC} GNUMAKE=${GMAKE} ${SH} make-config.sh --prefix=${PREFIX} --xc-host=${SBCL_BOOT_SYSTEM:Q} ${SBCL_BUILD_OPTIONS}

post-configure:
	@SRC_VERSION=$$(${TAIL} -n1 ${WRKSRC}/version.lisp-expr); \
		VERSION=$$( ${ECHO} "$${SRC_VERSION}" | \
		${SED} -e 's@"\([1-9][0-9]*\.[1-9][0-9]*\.[1-9][0-9]*\).*"@\1@g;' ); \
	  if [ "$${VERSION}" != "${SBCL_PATCHVERSION}" ]; then \
		echo "#-- ${PKGPATH}: Version Mismatch: Source patchlevel version $${VERSION} of $${SRC_VERSION} does not match ${SBCL_PATCHVERSION}" 1>&2; \
		exit 1; else echo "#-- ${PKGPATH}: Build for source version $${SRC_VERSION}"; \
	  fi

## Primary Build, Install, Test

do-build:
	cd ${WRKSRC} && ${ENV} CC=${CC} GNUMAKE=${GMAKE} ${SH} make.sh --prefix=${PREFIX} --xc-host=${SBCL_BOOT_SYSTEM:Q} ${SBCL_BUILD_OPTIONS}
post-build:
	${TEST} -n "${SBCL_BUILD_DOCS}" && ${GMAKE} -C ${WRKSRC}/doc/manual/ info MAKEINFO=${MAKEINFO}
	cd ${WRKSRC} && ${RM} -f contrib/sb-cover/test-output/*

do-install: do-remove-info-dir
	cd ${WRKSRC} && BUILD_ROOT=${DESTDIR} INSTALL_ROOT=${PREFIX} MAN_DIR=${PREFIX}/${PKGMANDIR} ${SH} install.sh
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/asdf-install/installer.lisp.orig
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/sb-posix/posix-tests.lisp.orig
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/sb-posix/test-output/write-test.txt
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/sb-posix/test-output/read-test.txt
	rm -f ${DESTDIR}${PREFIX}/bin/sbcl.old ${DESTDIR}${PREFIX}/lib/sbcl/sbcl.core.old
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
