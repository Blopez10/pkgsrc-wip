# $NetBSD: options.mk,v 1.4 2005/03/31 00:20:50 riz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.asterisk
PKG_SUPPORTED_OPTIONS=	zaptel gtk
.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mzaptel)
# zaptel only supported under NetBSD at the moment
.  include "../../wip/zaptel-netbsd/buildlink3.mk"
MAKE_FLAGS+=	ASTERISK_USE_ZAPTEL=1
PLIST_SUBST+=		ZAPTEL=
.else
PLIST_SUBST+=		ZAPTEL="@comment "
.endif

.if !empty(PKG_OPTIONS:Mgtk)
.  include "../../x11/gtk/buildlink3.mk"
MAKE_FLAGS+=	ASTERISK_USE_GTK=1
PLIST_SUBST+=		GTK=
.else
PLIST_SUBST+=		GTK="@comment "
.endif
