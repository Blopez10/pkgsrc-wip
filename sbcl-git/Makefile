# $NetBSD: Makefile,v 1.43 2014/10/09 14:06:30 thomasklausner Exp $

DISTNAME=		${PKGNAME_NOREV}-source
PKGNAME=		sbcl-1.0.55
CATEGORIES=		lang
MASTER_SITES=		${MASTER_SITE_SOURCEFORGE:=sbcl/}
EXTRACT_SUFX=		.tar.bz2

MAINTAINER=		asau@users.sourceforge.net
HOMEPAGE=		http://www.sbcl.org/
COMMENT=		SBCL, a Common Lisp implementation

# SBCL creates a new release with minor updates and fixes every
# month.  The maintainer of this package does not have the time
# to build, test, update, etc. this package that often.  If you
# would like a newer (or older) version, this works very often:
# 1) change the PKGNAME variable above as desired
# 2) make fetch && make makesum && make package

USE_TOOLS+=		gmake gtar:run patch

WRKSRC=			${WRKDIR}/${PKGNAME_NOREV}

.include "../../mk/bsd.prefs.mk"

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
USE_TOOLS+=		gmake
INFOFILES+=		${WRKSRC}/doc/manual/*.info ${WRKSRC}/doc/manual/*.info-*

do-install:
	rm -f ${DESTDIR}${PREFIX}/share/info/dir
.endif

pre-build:
	cd ${WRKSRC} && ${ECHO} '"1.0.99"' > version.lisp-expr
do-build:
	cd ${WRKSRC} && ${ENV} CC=${CC} ${SH} make.sh --prefix=${PREFIX} --xc-host=${SBCL_BOOT_SYSTEM:Q} ${SBCL_BUILD_OPTIONS}
post-build:
	${TEST} -n "${SBCL_BUILD_DOCS}" && ${GMAKE} -C ${WRKSRC}/doc/manual/ info MAKEINFO=${MAKEINFO}	
	cd ${WRKSRC} && ${RM} -f contrib/sb-cover/test-output/*

do-install:
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

GIT_REPOSITORIES=	sbcl
GIT_REPO.sbcl=		git://git.code.sf.net/p/sbcl/sbcl
WRKSRC=			${WRKDIR}/sbcl
DISTNAME=
PKGNAME=		sbcl-1.99

.include "../mk/git-package.mk"

.include "../../mk/bsd.pkg.mk"
