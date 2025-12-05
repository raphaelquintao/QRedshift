ARCHS = x86_64 i686 aarch64 armv7l armv5tel mips64el mipsel powerpc64le s390x

CC.x86_64 = x86_64-linux-gnu-gcc
CC.i686 = i686-linux-gnu-gcc
CC.aarch64 = aarch64-linux-gnu-gcc
CC.armv7l = arm-linux-gnueabihf-gcc
CC.armv5tel = arm-linux-gnueabi-gcc
CC.mips64el = mips64el-linux-gnuabi64-gcc
CC.mipsel = mipsel-linux-gnu-gcc
CC.powerpc64le = powerpc64le-linux-gnu-gcc
CC.s390x = s390x-linux-gnu-gcc

BIN.x86_64 = qredshift_x86_64
BIN.i686 = qredshift_i686
BIN.aarch64 = qredshift_aarch64
BIN.armv7l = qredshift_armv7l
BIN.armv5tel = qredshift_armv5tel
BIN.mips64el = qredshift_mips64el
BIN.mipsel = qredshift_mipsel
BIN.powerpc64le = qredshift_powerpc64le
BIN.s390x = qredshift_s390x

DOCKER_IMAGE_NAME = qredshift-cross

# Flags
CFLAGS = -lX11 -lXrandr -lxcb -lxcb-randr -lm
CFLAGS2 = -l X11 -lXrandr -lxcb -lxcb-randr -lm

# Directories
SRC_DIR = src
INCLUDE_DIR = include
BUILD_DIR = build

# Files
SRCS = $(shell find $(SRC_DIR) -name '*.c')
HEADS = $(shell find $(SRC_DIR) -name '*.h')
#OBJS = $(SRCS:.c=.o)

OBJS = $(addprefix $(BUILD_DIR)/, $(notdir $(SRCS:.c=.o)))

#OBJS = $(subst $(SRC_DIR),$(BUILD_DIR),$(SRCS:.c=.o))

# Local ARCH
ARCH = $(shell uname -m)
PWD = $(shell pwd)
U = $(shell id -u $(SUDO_USER)):$(shell id -g $(SUDO_USER))


.PHONY: all

target: $(BUILD_DIR)/$(BIN.$(ARCH))
	@echo Built $(BUILD_DIR)/$(BIN.$(ARCH))

all:
	@echo ===\> Building for current Arch \<===
	@make $(ARCH)

cross-docker:
	@echo ===\> Building with DOCKER \<===
	@echo USER: $(U)
	@if [ -z "$$(docker images -q $(DOCKER_IMAGE_NAME))" ]; then \
		echo "Image $(DOCKER_IMAGE_NAME) does not exist, proceeding with build..."; \
		docker build . -t $(DOCKER_IMAGE_NAME);\
	else \
		echo "Image $(DOCKER_IMAGE_NAME) already exists."; \
	fi
	@docker run -it -v $(PWD):/qredshift -u $(U) qredshift-cross make $(ARCHS)


$(ARCHS):
	@echo ===\> Building for $@ \<===
	@rm -f $(BUILD_DIR)/$(BIN.$@)
	@mkdir -p $(BUILD_DIR)
# 	@make $(OBJS) ARCH=$@
	@make $(BUILD_DIR)/$(BIN.$@) ARCH=$@ 1> /dev/null

# Build Directly
$(BUILD_DIR)/$(BIN.$(ARCH)): $(SRCS)
	@$(CC.$(ARCH)) $(SRCS) -o $@ $(CFLAGS)

#$(ARCHS):
#	@echo ===\> Building for $@ \<===
#	@make $(OBJS)
#	@make $(BUILD_DIR)/$(BIN.$@)
#
## Build Temporaly files
#$(OBJS): $(SRCS)
#	@mkdir -p $(dir $@)
#	@$(CC.$(ARCH)) -c $< -o $@
#
#
## Link the object files to create the final executable
#$(BUILD_DIR)/$(BIN.$(ARCH)): $(OBJS)
#	@echo $(OBJS)
#	$(CC.$(ARCH)) -o $@ $(OBJS) $(CFLAGS)



clean:
	@rm -rf build/*

run:
	./$(BUILD_DIR)/$(BIN.$(ARCH))