# $NetBSD$

BUILDLINK_TREE+=	wayland

.if !defined(WAYLAND_BUILDLINK3_MK)
WAYLAND_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.wayland+=	wayland>=1.9.90
BUILDLINK_PKGSRCDIR.wayland?=	../../wip/wayland

.include "../../mk/bsd.prefs.mk"
.if ${OPSYS} != "Linux"
.  include "../../wip/libepoll-shim/buildlink3.mk"
.endif
.include "../../devel/libffi/buildlink3.mk"
.endif	# WAYLAND_BUILDLINK3_MK

BUILDLINK_TREE+=	-wayland
