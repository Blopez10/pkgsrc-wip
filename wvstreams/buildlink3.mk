# $NetBSD: buildlink3.mk,v 1.1 2009/03/11 14:57:44 udontknow Exp $

BUILDLINK_DEPTH:=		${BUILDLINK_DEPTH}+
WVSTREAMS_BUILDLINK3_MK:=	${WVSTREAMS_BUILDLINK3_MK}+

.if ${BUILDLINK_DEPTH} == "+"
BUILDLINK_DEPENDS+=	wvstreams
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Nwvstreams}
BUILDLINK_PACKAGES+=	wvstreams
BUILDLINK_ORDER:=	${BUILDLINK_ORDER} ${BUILDLINK_DEPTH}wvstreams

.if ${WVSTREAMS_BUILDLINK3_MK} == "+"
BUILDLINK_API_DEPENDS.wvstreams+=	wvstreams>=4.5.1
BUILDLINK_PKGSRCDIR.wvstreams?=	../../wip/wvstreams
.endif	# WVSTREAMS_BUILDLINK3_MK

BUILDLINK_DEPTH:=		${BUILDLINK_DEPTH:S/+$//}
