# faust-vst-qt

Copyright (c) 2014-2015 by Albert Gräf  
Copyright (c) 2015 by Roman Svidler

This software is distributed under the Lesser GNU Public License (LGPL);
please check the included COPYING and COPYING.LESSER files for details.

This is an extension of Albert Gräf's faust-vst
architecture. (https://bitbucket.org/agraef/faust-vst) It provides
experimental support for native Qt GUIs in Faust-generated VST plugins.

**NOTES:** This is work in progress. Only Linux is supported at present. To
use this architecture, Faust, the VST SDK and Qt are needed, so you'll want to
install these beforehand. Please also check the upstream faust-vst
documentation for further information.

A Makefile is included. Running `make all` or just `make` will create the
`faust2faustvstqt` shell script and compile the sample plugins in the
`examples` subfolder. Running `make install` installs the sample plugins in
your system VST directory, `make uninstall` uninstalls them again.

Running `make install-faust` installs the `faust2faustvstqt` script and the
`faustvstqt.cpp` architecture in the appropriate places (use `make
uninstall-faust` to uninstall these again). After doing `make install-faust`,
you should be able to compile your own Faust dsps with the installed
`faust2faustvstqt` shell script. Or just drop them into the `examples` folder
and run `make` again.

Also have a look at the Makefile for various compilation options.
