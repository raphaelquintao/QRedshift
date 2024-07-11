# ARCHS = amd64 i386 arm64 armhf armel mips64el mipsel ppc64el s390x 

# CC.amd64 = x86_64-linux-gnu-gcc
# CC.i386 = i686-linux-gnu-gcc
# CC.arm64 = aarch64-linux-gnu-gcc
# CC.armhf = arm-linux-gnueabihf-gcc
# CC.armel = arm-linux-gnueabi-gcc
# CC.mips64el = mips64el-linux-gnuabi64-gcc
# CC.mipsel = mipsel-linux-gnu-gcc
# CC.ppc64el = powerpc64le-linux-gnu-gcc
# CC.s390x = s390x-linux-gnu-gcc

# BIN.amd64 = qredshift_x86_64
# BIN.i386 = qredshift_i686
# BIN.arm64 = qredshift_aarch64
# BIN.armhf = qredshift_armv7l
# BIN.armel = qredshift_armv5tel
# BIN.mips64el = qredshift_mips64el
# BIN.mipsel = qredshift_mipsel
# BIN.ppc64el = qredshift_ppc64le
# BIN.s390x = qredshift_s390x

ARCHS = x86_64 i686 aarch64 rmv7l armv5tel mips64el mipsel powerpc64le s390x 

CC.x86_64 = x86_64-linux-gnu-gcc
CC.i686 = i686-linux-gnu-gcc
CC.aarch64 = aarch64-linux-gnu-gcc
CC.rmv7l = arm-linux-gnueabihf-gcc
CC.armv5tel = arm-linux-gnueabi-gcc
CC.mips64el = mips64el-linux-gnuabi64-gcc
CC.mipsel = mipsel-linux-gnu-gcc
CC.powerpc64le = powerpc64le-linux-gnu-gcc
CC.s390x = s390x-linux-gnu-gcc

BIN.x86_64 = qredshift_x86_64
BIN.i686 = qredshift_i686
BIN.aarch64 = qredshift_aarch64
BIN.rmv7l = qredshift_armv7l
BIN.armv5tel = qredshift_armv5tel
BIN.mips64el = qredshift_mips64el
BIN.mipsel = qredshift_mipsel
BIN.powerpc64le = qredshift_powerpc64le
BIN.s390x = qredshift_s390x

# Flags
CFLAGS = -lX11 -lXrandr -lxcb -lxcb-randr -lm

# Directories
SRC_DIR = src
BUILD_DIR = build

# Source Files
SRCS = $(shell find $(SRC_DIR) -name '*.c')
# Local ARCH
ARCH = $(shell uname -m)

.PHONY:	default

default:
	@echo ===\> Building for current Arch \<===
	@make $(ARCH)

all-docker:
	@docker build . -t qredshift-cross
	@docker run -itd -v /etc/passwd:/etc/passwd -v /etc/group:/etc/group -v .:/qredshift -u 1000:1000 qredshift-cross make all

all:
	@echo ===\> Building ALL \<===
	@make $(ARCHS)

$(ARCHS):
	@echo ===\> Building for $@ \<===
	@rm -f $(BUILD_DIR)/$(BIN.$@)
	@mkdir -p $(BUILD_DIR)
# 	@make $(OBJS) ARCH=$@
	@make $(BUILD_DIR)/$(BIN.$@) ARCH=$@ 1> /dev/null

# Build Temporaly files
# $(OBJS): $(SRCS)
# 	@mkdir -p $(dir $@)
# 	@$(CC.$(ARCH)) -c $< -o $@

# Link the object files to create the final executable
# $(BUILD_DIR)/$(BIN.$(ARCH)): $(OBJS)
# 	@$(CC.$(ARCH)) $(OBJS) -o $@ $(CFLAGS)

# Build Directly
$(BUILD_DIR)/$(BIN.$(ARCH)): $(SRCS)
	@$(CC.$(ARCH)) $(SRCS) -o $@ $(CFLAGS)




