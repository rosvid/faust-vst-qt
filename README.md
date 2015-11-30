# faust-vst-qt

Copyright (c) 2014-2015 by Albert Gräf  
Copyright (c) 2015 by Roman Svidler

This software is distributed under the Lesser GNU Public License (LGPL); please check the included COPYING and COPYING.LESSER files for details.

This is an extension of Albert Gräf's faust-vst architecture. (https://bitbucket.org/agraef/faust-vst) It provides experimental support for native Qt GUIs in Faust-generated VST plugins.

**NOTES:** This is work in progress. Only Linux is supported at present. To use this architecture, Faust, the VST SDK and Qt are needed, so you'll want to install these beforehand. Please also check the upstream faust-vst documentation for further information.

The Makefile is largely dysfunctional right now, but the targets `make all`, `make install-faust` and `make uninstall-faust` are supposed to work.

After doing `make install-faust`, you should be able to compile the examples with the `make-all.sh` shell script in the `examples` subdirectory. For the time being, ready-made 64 bit Linux executables are included in the `examples_vstqt.zip` file. You can drop these into your VST plugin folder to give them a try with your favorite VST host. (The binaries have been built on Manjaro/Arch and are linked against recent versions of the X.Org and Qt5 libraries.)
