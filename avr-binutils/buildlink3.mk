# $NetBSD: buildlink3.mk,v 1.4 2014/10/27 08:56:17 makoto Exp $

BUILDLINK_TREE+=	avr-binutils

.if !defined(AVR_BINUTILS_BUILDLINK3_MK)
AVR_BINUTILS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.avr-binutils+=	avr-binutils>=2.23
BUILDLINK_PKGSRCDIR.avr-binutils?=		../../cross/avr-binutils
#BUILDLINK_FNAME_TRANSFORM.avr-binutils+=	-e "s,${AVR_TARGET}/lib,lib/,g"

.endif # AVR_BINUTILS_BUILDLINK3_MK

BUILDLINK_TREE+=	-avr-binutils
