$NetBSD: patch-examples_reverse__client__cb.cc,v 1.1 2013/02/21 22:25:04 jonperkin Exp $

Need unistd.h for STDOUT_FILENO.

--- examples/reverse_client_cb.cc.orig	2013-02-01 20:23:35.000000000 +0000
+++ examples/reverse_client_cb.cc
@@ -43,6 +43,7 @@
 #include <iomanip>
 #include <iostream>
 #include <string>
+#include <unistd.h>
 
 #include <libgearman/gearman.h>
 #include <boost/program_options.hpp>
