# $Thinkum$

DISTNAME=	docbook-45-relaxng
PKGNAME=	${DISTNAME}-4.5
PKGREVISION=	1
CATEGORIES=	textproc

MAINTAINER=	qa@thinkum.space
HOMEPAGE=	https://www.docbook.org/
COMMENT=	Docbook 4.5 grammar in RELAX NG XML and Compact notations
LICENSE=	# TBD

MASTER_SITES+=	https://docbook.org/rng/4.5/
DIST_SUBDIR=	${DISTNAME}
.for MOD in calstblx dbhierx dbnotnx dbpoolx docbook htmltblx
.  for TYP in rnc rng
DISTFILES+=	${MOD}.${TYP}
DB45R_SRC+=	${DISTDIR}/${DIST_SUBDIR}/${MOD}.${TYP}
#DB45R_PLIST+=	share/xml/docbook/4.5/${MOD}.${TYP}
.  endfor
.endfor

## unused, now that this pkg uses a static PLIST
#.for F in ${DB45R_PLIST}
#GENERATE_PLIST+=	${ECHO} ${F};
#.endfor

NO_CONFIGURE=	# Defined
NO_BUILD=	# Defined

do-install:
	${INSTALL_DATA_DIR} ${DESTDIR}${PREFIX}/share/xml/docbook/4.5
	${INSTALL_DATA} ${DB45R_SRC} ${DESTDIR}${PREFIX}/share/xml/docbook/4.5

## NB: There is not any formal XML catalog pubished for the RELAX NG XML
## and/or RELAX NG Compact notations of the DocBook 4.5 grammars
##
## vis a vis http://www.oasis-open.org/docbook/xml/4.5/
## furthermore https://docbook.org/schemas/4x

.include "../../mk/bsd.pkg.mk"
