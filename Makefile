#variables de compilation
SHELL = /bin/sh
CXX   = g++

DEFINES = -DBYPASS_PROTECTION

CXXFLAGS += -O3 -flto -Wall -ffast-math -MMD -Wuninitialized -Wundef -Wreorder $(shell  pkgconf sdl2 SDL2_mixer gl zlib --cflags) $(DEFINES)
LDFLAGS  += $(shell pkgconf sdl2 SDL2_mixer gl zlib --libs)
TARGET   = rawgl
#variable de nettoyage
RM_F = rm -f
#variables d'instalation
INSTALL = install
INSTALL_DIR     = $(INSTALL) -p -d -o root -g root  -m  755
INSTALL_PROGRAM = $(INSTALL) -p    -o root -g root  -m  755

prefix = /usr
exec_prefix = $(prefix)
bindir = $(exec_prefix)/games

SRCS = aifcplayer.cpp bitmap.cpp file.cpp engine.cpp graphics_gl.cpp graphics_soft.cpp \
	script.cpp mixer.cpp pak.cpp resource.cpp resource_mac.cpp resource_nth.cpp \
	resource_win31.cpp resource_3do.cpp systemstub_sdl.cpp sfxplayer.cpp staticres.cpp \
	unpack.cpp util.cpp video.cpp main.cpp

OBJS = $(SRCS:.cpp=.o)
DEPS = $(SRCS:.cpp=.d)

#parallel compilation if available
ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
 NUMJOBS = $(patsubst parallel=%,%,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
 MAKEFLAGS += -j$(NUMJOBS)
endif

export

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) -flto -o $@ $(OBJS) $(LDFLAGS)

install: $(TARGET)
	$(INSTALL_DIR) $(DESTDIR)$(bindir)
	-@$(RM_F) $(DESTDIR)$(bindir)/$(TARGET)
	$(INSTALL_PROGRAM) $(TARGET) $(DESTDIR)$(bindir)

clean:
	-@$(RM_F) $(OBJS) $(DEPS) $(TARGET)

-include $(DEPS)
