# $NetBSD$

PKGNAME=	iosevka-ttf-2.3.0
DISTNAME=	01-${PKGNAME:S/-ttf//}
CATEGORIES=	fonts
MASTER_SITES=	${MASTER_SITE_GITHUB:=be5invis/}
GITHUB_PROJECT=	Iosevka
GITHUB_RELEASE=	v${PKGVERSION_NOREV}

MAINTAINER=	iku.iwasa@gmail.ccom
HOMEPAGE=	https://github.com/be5invis/Iosevka
COMMENT=	Slender typeface for code, from code
LICENSE=	ofl-v1.1

EXTRACT_DIR=	${WRKSRC}
EXTRACT_SUFX=	.zip

NO_BUILD=	yes
USE_LANGUAGES=	# none

FONTSDIR=	share/fonts/X11/TTF

INSTALLATION_DIRS=	${FONTSDIR}

do-install:
	${INSTALL_DATA} ${WRKSRC}/ttf/*.ttf ${DESTDIR}/${PREFIX}/${FONTSDIR}

.include "../../mk/bsd.pkg.mk"
