# faust-vst-qt

Copyright (c) 2014-2016 by Albert Gräf  
Copyright (c) 2015-2016 by Roman Svidler

This software is distributed under the Lesser GNU Public License (LGPL);
please check the included COPYING and COPYING.LESSER files for details.

This is an extension of Albert Gräf's faust-vst
architecture. (https://bitbucket.org/agraef/faust-vst) It provides
experimental support for native Qt GUIs in Faust-generated VST plugins.

**NOTES:** This is work in progress. Only Linux is supported at present. To
use this architecture, Faust, the VST SDK and Qt are needed, so you'll want to
install these beforehand. Please also check the upstream faust-vst
documentation for further information.

## Installation

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

## Known Bugs

The plugin architecture works by embedding Qt GUIs in windows provided by the
VST host, which unfortunately seems to cause trouble with some host
applications. Below is a list of known issues related to different hosts;
we'll hopefully be able to fix these in the future. If you notice any other
issues then please file a detailed bug report with all information (including
gdb backtraces etc.) that you can get hold of.

- VSTi GUIs show the `freq`, `gain` and `gate` "voice" parameters of
  instrument dsps, which are supposed to be invisible to the user as they are
  set by incoming MIDI note data. This affects all hosts. In the current
  implementation these controls are simply disabled (grayed out), but they
  will be completely hidden in the future.

- Some plugins cause audio dropouts with some VST hosts when their GUI is
  opened. The reasons for this aren't clear yet, and we don't know whether the
  plugin architecture or the host is to blame. For the time being, you can
  work around this by opening the corresponding GUIs before starting playback.

- The plugins won't work directly in Ardour at present (Ardour will hang if
  you try this). However, you can work around this by running them inside
  falkTX's [Carla plugin](https://github.com/falkTX/Carla) instead. (Make sure
  that you use Carla LV2 rather than Carla VST in Ardour; we found that the
  latter causes crashes when loading the Faust VST plugins inside Carla.)

- Plugin windows have the wrong size and come up without scroll bars when they
  are opened for the first time in Qtractor. You can work around this by just
  closing and reopening the GUIs, they will look all right the second and
  subsequent times. Or run them through Carla, it will get the display right
  on first attempt. :)
