# $NetBSD: buildlink3.mk,v 1.1 2009/01/12 03:19:29 phonohawk Exp $

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH}+
HAPPY_BUILDLINK3_MK:=	${HAPPY_BUILDLINK3_MK}+

.if ${BUILDLINK_DEPTH} == "+"
BUILDLINK_DEPENDS+=	happy
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Nhappy}
BUILDLINK_PACKAGES+=	happy
BUILDLINK_ORDER:=	${BUILDLINK_ORDER} ${BUILDLINK_DEPTH}happy

.if ${HAPPY_BUILDLINK3_MK} == "+"
BUILDLINK_DEPMETHOD.happy?=	build
BUILDLINK_API_DEPENDS.happy+=	happy>=1.18.2
BUILDLINK_PKGSRCDIR.happy?=	../../wip/happy
.endif	# HAPPY_BUILDLINK3_MK

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH:S/+$//}
