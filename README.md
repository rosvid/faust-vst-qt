# faust-vst-qt

Copyright (c) 2014-2016 by Albert Gräf  
Copyright (c) 2015-2016 by Roman Svidler

This software is distributed under the Lesser GNU Public License (LGPL);
please check the included COPYING and COPYING.LESSER files for details.

This is an extension of the faust-vst architecture
(https://bitbucket.org/agraef/faust-vst). It provides experimental support for
native Qt GUIs in Faust-generated VST plugins.

**NOTES:** This is work in progress, so expect some bugs. Only Linux is
supported at present. To use this architecture, Faust, the VST SDK and Qt are
needed, so you'll want to install these beforehand. Please also check the
upstream faust-vst documentation for further information.

## Installation

A Makefile is included. Running `make all` or just `make` will create the
`faust2faustvstqt` shell script and compile the sample plugins in the
`examples` subfolder. Running `make install` installs the sample plugins in
your system VST directory, `make uninstall` uninstalls them again. This step
is optional, but gives you a quick way to install the sample plugins in a
place where you can test them with your favourite VST host.

Running `make install-faust` installs the `faust2faustvstqt` script and the
`faustvstqt.cpp` architecture in the appropriate places (use `make
uninstall-faust` to uninstall these again). After doing this, you should be
able to compile your own Faust dsps with the installed `faust2faustvstqt`
shell script. Or just drop them into the `examples` folder and run `make`
again.

Also have a look at the Makefile for various compilation options.

## Compiling Plugins

The `faust2faustvstqt` script provides a convenient way to compile a Faust
program to a VST plugin. Please check the upstream documentation for a
description of the available compilation options, or run the script with
`faust2faustvstqt -h` to get a brief summary.

In addition to the options available with faust-vst, the following GUI-related
options are available:

- The `-voicectrls` option only has an effect on instrument plugins. It adds
  an extra polyphony slider (and, if applicable, also a tuning slider) at the
  bottom of the GUI. Note that these aren't actual Faust-generated parameters
  but are added by the VST architecture so that you can control the number of
  synth voices and the MTS tuning of the synth at runtime. They aren't
  included in the GUI by default so that only the actual Faust control
  variables of the synth will be shown. (Even then you can still control these
  extra parameters using automation or whatever generic user interface the VST
  host provides.) However, you may want to add these for convenience.

- The `-style` option selects the stylesheet to be used. This must be the
  basename of a stylesheet in `<faust-prefix>/include/faust/gui/Styles/` (one
  of Default, Blue, Grey, Salmon at the time of this writing). If this option
  is not used then the default Qt style will be used (which is generally
  preferable since it allows the GUI to use a theme set through the desktop
  environment and/or the host application).

- The `-keep` option retains the build directory after compilation is
  completed. When using this option, the build directory won't be deleted but
  can be found under the dsp basename after compilation. This is useful for
  debugging and inspection purposes, if there are C++ compilation errors to be
  sorted out, or if you want to customize the C++ sources of the plugin.

- The `-osc`, `-http` and `-qrcode` options have the same meaning as with the
  stand-alone Faust architectures (cf. `faust2jaqt` et al). They add OSC and
  HTTP support which allows a plugin to be controlled via OSC (Open Sound
  Control) devices and through web browsers. Please check the sections "OSC
  support" and "HTTP support" in the *Faust Quick Reference* manual for
  details.

**NOTES:** The `-http` option can be used together with `-qrcode` to have a
window with the URL of the plugin pop up every time the plugin GUI is opened.
This window also displays the URL as a QR code which is convenient to access
the web interface from mobile devices. Both the OSC server and the web server
of a plugin is tied to its Qt GUI and will only be available as long as the
GUI remains open in the host application. Also note that the OSC and HTTP
ports are assigned dynamically and may thus vary each time a plugin GUI is
opened, depending on which other GUIs of OSC/HTTP-enabled plugins are open at
the time. (At the time of this writing, the HTTP server uses TCP ports
starting at 5510 by default. The OSC server will assign UDP ports starting at
5510, which is the port at which the first open plugin listens for OSC
commands.  Ports 5511 and 5512 are used as the output and error ports for all
plugins. The next plugin then uses 5513 as its OSC input port, etc.)

## Known Bugs

VST plugins with Qt5 GUIs are known to be problematic with some hosts on
Linux. In our tests, the plugin GUIs worked fine with Bitwig Studio, Carla and
Qtractor, but caused occasional crashes with Tracktion6 and didn't work at all
with Ardour. We hope to get these issues sorted out some time, but for now the
plugin GUIs have been disabled in the latter two hosts. We suggest running the
plugins through falkTX's plugin host [Carla](https://github.com/falkTX/Carla)
in Ardour and Tracktion6 instead, this seems to work fine.

Please submit a bug report if you notice any further issues. Of course,
suggestions, pull requests and patches are also appreciated.
