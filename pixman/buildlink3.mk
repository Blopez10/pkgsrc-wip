# $NetBSD: buildlink3.mk,v 1.2 2007/08/06 17:00:11 bsadewitz Exp $

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH}+
PIXMAN_BUILDLINK3_MK:=	${PIXMAN_BUILDLINK3_MK}+

.if ${BUILDLINK_DEPTH} == "+"
BUILDLINK_DEPENDS+=	pixman
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Npixman}
BUILDLINK_PACKAGES+=	pixman
BUILDLINK_ORDER:=	${BUILDLINK_ORDER} ${BUILDLINK_DEPTH}pixman

.if ${PIXMAN_BUILDLINK3_MK} == "+"
BUILDLINK_API_DEPENDS.pixman+=	pixman>=0.9.3
BUILDLINK_PKGSRCDIR.pixman?=	../../wip/pixman
.endif	# PIXMAN_BUILDLINK3_MK

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH:S/+$//}
