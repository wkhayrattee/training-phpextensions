dnl config.m4
PHP_ARG_ENABLE(hello, whether to enable Hello World support, [ --enable-hello   Enable Hello World support])

if test "$PHP_HELLO" != "no"; then
  PHP_NEW_EXTENSION(hello, hello.c, $ext_shared)
fi
