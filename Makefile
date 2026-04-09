#makefile
ARCHS = x86_64 i686 aarch64 armv7l armv5tel mips64el mipsel powerpc64le s390x

CC_x86_64 = x86_64-linux-gnu-gcc
CC_i686    = i686-linux-gnu-gcc
CC_aarch64 = aarch64-linux-gnu-gcc
CC_armv7l  = arm-linux-gnueabihf-gcc
CC_armv5tel= arm-linux-gnueabi-gcc
CC_mips64el= mips64el-linux-gnuabi64-gcc
CC_mipsel  = mipsel-linux-gnu-gcc
CC_powerpc64le = powerpc64le-linux-gnu-gcc
CC_s390x   = s390x-linux-gnu-gcc

BIN_x86_64 = qredshift_x86_64
BIN_i686    = qredshift_i686
BIN_aarch64 = qredshift_aarch64
BIN_armv7l  = qredshift_armv7l
BIN_armv5tel= qredshift_armv5tel
BIN_mips64el= qredshift_mips64el
BIN_mipsel  = qredshift_mipsel
BIN_powerpc64le = qredshift_powerpc64le
BIN_s390x   = qredshift_s390x

VERSION = 0.12
DOCKER_IMAGE_NAME = qredshift-cross
PWD = $(shell pwd)
U = $(shell id -u $(SUDO_USER)):$(shell id -g $(SUDO_USER))
arch ?= $(shell uname -m)
cc_default = cc

src_dir = src
build_dir = build
srсs = $(shell find $(src_dir) -name '*.c')

#cflags = -O2 -Wall $(shell pkg-config --cflags gio-2.0 glib-2.0 x11 xrandr xcb xcb-randr)
#ldflags = $(shell pkg-config --libs gio-2.0 glib-2.0 x11 xrandr xcb xcb-randr) -lm
cflags = -O2 -Wall $(shell pkg-config --cflags x11 xrandr xcb xcb-randr)
ldflags = $(shell pkg-config --libs x11 xrandr xcb xcb-randr) -lm


bin = $(if $(BIN_$(arch)),$(BIN_$(arch)),qredshift_$(arch))
cc_sel = $(if $(CC_$(arch)),$(CC_$(arch)),$(cc_default))

.PHONY: all clean run $(ARCHS) cross build

all: build

# build for each arch by running a sub-make with arch set
$(ARCHS):
	@echo ===\> building for $@ \<===
	@make arch=$@

build: $(build_dir)/$(bin)
	@echo Built $<

$(build_dir)/$(bin): $(srсs)
	@mkdir -p $(build_dir)
	$(cc_sel) $(srсs) -o $@ $(cflags) $(ldflags)

clean:
	rm -rf $(build_dir)/*

run: build
	./$(build_dir)/$(bin) $@

deb: build
	@chmod +x scripts/make_deb.sh
	@./scripts/make_deb.sh $(arch) $(bin) $(VERSION)

debs:
	@for a in $(ARCHS); do \
	  make arch=$$a deb; \
	done

docker:
	@echo ===\> Building with DOCKER \<===
	@echo USER: $(U)
	@if [ -z "$$(docker images -q $(DOCKER_IMAGE_NAME))" ]; then \
		echo "Image $(DOCKER_IMAGE_NAME) does not exist, proceeding with build..."; \
		docker build . -t $(DOCKER_IMAGE_NAME);\
	else \
		echo "Image $(DOCKER_IMAGE_NAME) already exists."; \
	fi
	@docker run -it -v $(PWD):/qredshift -u $(U) qredshift-cross make $(ARCHS) debs
