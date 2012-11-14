$NetBSD: patch-cmake_modules_FindCHOLMOD.cmake,v 1.1 2012/11/14 23:18:38 outpaddling Exp $

--- cmake/modules/FindCHOLMOD.cmake.orig	2011-12-07 21:21:22.000000000 +0000
+++ cmake/modules/FindCHOLMOD.cmake
@@ -66,6 +66,7 @@ endif()
 if (LAPACK_FOUND)
   set(CHOLMOD_LIBRARIES ${CHOLMOD_LIBRARIES} ${LAPACK_LIBRARIES})
 endif()
+set(CHOLMOD_LIBRARIES ${CHOLMOD_LIBRARIES} -lsuitesparseconfig)
 
 mark_as_advanced(
   CHOLMOD_INCLUDE_DIRS
