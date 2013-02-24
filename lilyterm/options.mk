# $NetBSD: options.mk,v 1.1 2013/02/24 23:17:38 othyro Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.lilyterm
PKG_SUPPORTED_OPTIONS=	debug gnome nls
PKG_SUGGESTED_OPTIONS=	gnome nls
PLIST_VARS+=		nls

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mdebug)
CONFIGURE_ARGS+=	--enable-debug
.else
CONFIGURE_ARGS+=	--disable-debug
.endif

.if !empty(PKG_OPTIONS:Mgnome)
.include "../../x11/gnome-control-center/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-gnome-control-center
PLIST.gnome=		yes
.else
CONFIGURE_ARGS+=	--disable-gnome-control-center
.endif

.if !empty(PKG_OPTIONS:Mnls)
.include "../../devel/gettext-lib/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-nls
PLIST.nls=		yes
.else
CONFIGURE_ARGS+=	--disable-nls
.endif
