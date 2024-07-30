PHP_ARG_WITH([bz2],
  [for BZip2 support],
  [AS_HELP_STRING([[--with-bz2[=DIR]]],
    [Include BZip2 support])])

if test "$PHP_BZ2" != "no"; then
  AS_IF([test -r $PHP_BZ2/include/bzlib.h], [BZIP_DIR=$PHP_BZ2], [
    for i in /usr/local /usr; do
      AS_IF([test -r $i/include/bzlib.h], [BZIP_DIR=$i; break;])
    done
  ])

  AC_MSG_CHECKING([for BZip2])
  AS_VAR_IF([BZIP_DIR],, [
    AC_MSG_RESULT([bzlib.h not found])
    AC_MSG_ERROR([Please reinstall the BZip2 library package])
  ], [AC_MSG_RESULT([found in $BZIP_DIR])])

  PHP_CHECK_LIBRARY([bz2], [BZ2_bzerror], [
    PHP_ADD_INCLUDE([$BZIP_DIR/include])
    PHP_ADD_LIBRARY_WITH_PATH([bz2],
      [$BZIP_DIR/$PHP_LIBDIR],
      [BZ2_SHARED_LIBADD])
    AC_DEFINE([HAVE_BZ2], [1], [ ])
    ],
    [AC_MSG_ERROR([bz2 module requires libbz2 >= 1.0.0])],
    [-L$BZIP_DIR/$PHP_LIBDIR])

  PHP_NEW_EXTENSION([bz2], [bz2.c bz2_filter.c], [$ext_shared])
  PHP_SUBST([BZ2_SHARED_LIBADD])
fi
