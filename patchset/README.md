# Patch Set

Set of patches to get a working and consistent build of baton (and its
dependencies) within a Docker container.

## `iRODS-configure.diff`
The iRODS `configure` script is a Perl script which is part of a larger
installation routine. It can be run standalone and must be run to create
the necessary configuration dependencies (not autotools) for the
`make`-based build. However it imposes the restriction of not running as
root, which is irrelevant and meaningless to our context.

## `iRODS-lib-Makefile.diff`
The baton build complains when trying to link the iRODS library that it
can't reference absolute symbols, thus needing the `-fPIC` (position
independent code) C flag passed to GCC.
