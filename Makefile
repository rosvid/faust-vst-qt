# This is a GNU Makefile.

# Package name and version:
dist = faust-vst-qt-$(version)
version = 0.1

# Installation prefix and default installation dirs. NOTE: vstlibdir is used
# to install the plugins, bindir and faustlibdir for the Faust-related tools
# and architectures. You can also set these individually if needed.
prefix = /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib
vstlibdir = $(libdir)/vst
faustlibdir = $(libdir)/faust

# Try to guess the Faust installation prefix.
faustprefix = $(patsubst %/bin/faust,%,$(shell which faust 2>/dev/null))
ifeq ($(strip $(faustprefix)),)
# Fall back to /usr/local.
faustprefix = /usr/local
endif
incdir = $(faustprefix)/include
faustincdir = $(incdir)/faust

# Check for some common locations of the SDK files. This falls back to
# /usr/local/src/vstsdk if none of these are found. In that case, or if make
# picks the wrong location, you can also set the SDK variable explicitly.
sdkpaths = /usr/local/include /usr/local/src /usr/include /usr/src
sdkpat = vst* VST*
#SDK = /usr/local/src/vstsdk
SDK = $(firstword $(wildcard $(foreach path,$(sdkpaths),$(addprefix $(path)/,$(sdkpat)))) /usr/src/vstsdk)
# Steinberg's distribution zip has the SDK source files in the
# public.sdk/source/vst2.x subdirectory, while some Linux packages (e.g.,
# steinberg-vst on the AUR) keep them directly under $(SDK).
#SDKSRC = $(SDK)/public.sdk/source/vst2.x
SDKSRC = $(firstword $(patsubst %/,%,$(dir $(wildcard $(addsuffix vstplugmain.cpp,$(SDK)/ $(SDK)/public.sdk/source/vst2.x/)))) $(SDK)/public.sdk/source/vst2.x)

# Here are a few options which you can set. Please check the beginning of
# faust2faustvstqt.in for a closer explanation of these.

# ignore metadata (author information etc.) from the Faust source
# OPTS += -nometa
# plugin doesn't process MIDI control data
# OPTS += -nomidicc
# disable the tuning control (VSTi only)
# OPTS += -notuning
# number of synth voices (VSTi only; arg must be an integer)
# OPTS += -nvoices 16
# retain the build directory (useful if you want to change stuff manually)
# OPTS += -keep
# preferred widget style (qss); must be one of Default, Blue, Grey, Salmon
# OPTS += -style Grey

# Shared library suffix.
DLL = .so

# Try to guess the host system type and figure out platform specifics.
host = $(shell ./config.guess)
ifneq "$(findstring -mingw,$(host))" ""
# Windows (untested)
EXE = .exe
DLL = .dll
endif
ifneq "$(findstring -darwin,$(host))" ""
# OSX (untested)
DLL = .vst
endif

# DSP sources and derived files.
dspsource = $(sort $(wildcard */*.dsp))
plugins = $(patsubst %.dsp,%$(DLL),$(dspsource))
# for -keep
srcdirs = $(patsubst %.dsp,%,$(dspsource))

.PHONY: all clean install uninstall install-faust uninstall-faust dist distcheck

all: faust2faustvstqt $(plugins)

# This sets the proper SDK and Faust paths in the faust2faustvstqt script,
# detected at build time.
faust2faustvstqt: faust2faustvstqt.in
	sed -e 's?@SDK@?$(SDK)?g;s?@SDKSRC@?$(SDKSRC)?g;s?@FAUSTINC@?$(faustincdir)?g;s?@FAUSTLIB@?$(faustlibdir)?g' < $< > $@
	chmod a+x $@

# Generic build rules.

%$(DLL): %.dsp faust2faustvstqt
	+FAUSTLIB=$(CURDIR) ./faust2faustvstqt $(OPTS) -I examples $<

# Clean.

clean:
	rm -Rf faust2faustvstqt $(plugins) $(srcdirs)

# Install.

install: $(plugins)
	test -d $(DESTDIR)$(vstlibdir) || mkdir -p $(DESTDIR)$(vstlibdir)
	cp -Rf $(plugins) $(DESTDIR)$(vstlibdir)

uninstall:
	rm -Rf $(addprefix $(DESTDIR)$(vstlibdir)/, $(notdir $(plugins)))

# Use this to install the Faust architectures and scripts included in this
# package over an existing Faust installation.

install-faust: faust2faustvstqt
	test -d $(DESTDIR)$(bindir) || mkdir -p $(DESTDIR)$(bindir)
	cp faust2faustvstqt $(DESTDIR)$(bindir)
	test -d $(DESTDIR)$(faustlibdir) || mkdir -p $(DESTDIR)$(faustlibdir)
	cp faustvstqt.cpp editor_faustvstqt.h $(DESTDIR)$(faustlibdir)

uninstall-faust:
	rm -f $(DESTDIR)$(bindir)/faust2faustvstqt
	rm -f $(DESTDIR)$(faustlibdir)/faustvstqt.cpp
	rm -f $(DESTDIR)$(faustlibdir)/editor_faustvstqt.h

# Roll a distribution tarball.

DISTFILES = COPYING COPYING.LESSER Makefile README.md config.guess faust2faustvstqt.in editor_faustvstqt.h faustvstqt.cpp Info.plist.in examples/*.dsp examples/*.lib examples/*.h

dist:
	rm -rf $(dist)
	for x in $(dist) $(dist)/examples; do mkdir $$x; done
	for x in $(DISTFILES); do ln -sf "$$PWD"/$$x $(dist)/$$x; done
	rm -f $(dist).tar.bz2
	tar cfjh $(dist).tar.bz2 $(dist)
	rm -rf $(dist)

distcheck: dist
	tar xfj $(dist).tar.bz2
	cd $(dist) && make SDK=$(abspath $(SDK)) && make install DESTDIR=./BUILD
	rm -rf $(dist)
