ARCHS = amd64 i386 armhf arm64 ppc64el s390x

# Compilers
CC.amd64 = x86_64-linux-gnu-gcc
CC.i386 = i686-linux-gnu-gcc
CC.armhf = arm-linux-gnueabihf-gcc
CC.arm64 = aarch64-linux-gnu-gcc
CC.ppc64el = powerpc64le-linux-gnu-gcc
CC.s390x = s390x-linux-gnu-gcc

# Binaries Names
BIN.amd64 = qredshift_x86_64
BIN.i386 = qredshift_i386
BIN.armhf = qredshift_armhf
BIN.arm64 = qredshift_arm64
BIN.ppc64el = qredshift_ppc64el
BIN.s390x = qredshift_s390x


CFLAGS = -lX11 -lXrandr -lxcb -lxcb-randr -lm

# Source and build directories
SRC_DIR = src
BUILD_DIR = build



# List of source files
SRCS = $(shell find $(SRC_DIR) -name '*.c')

ARCH = $@

#OBJS = $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/$(ARCH)/%.o)
OBJS = $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/amd64/%.o)

$(ARCHS):
	@echo Building for $(ARCH)
	@#echo $@
	@#mkdir -p $(BUILD_DIR)/$@
	@#make build ARCH=$@
	@#make $(OBJS) ARCH=$@
	@make $(BUILD_DIR)/$(BIN.$(ARCH)) ARCH=$@
	@#make $(BUILD_DIR)/$@/$(BIN.$(@))

#build:
#	@mkdir -p $(BUILD_DIR)/$(ARCH)
#	$(BUILD_DIR)/$(ARCH)/$(BIN.$(ARCH))


#$(OBJS): $(SRCS)
#	@echo $<
#	@mkdir -p $(dir $@)
#	@$(CC.$(ARCH)) $(CFLAGS) -c $< -o $@


# Link the object files to create the final executable
#$(BUILD_DIR)/$(BIN.$(ARCH)): $(OBJS)
#	@mkdir -p $(BUILD_DIR)/$(ARCH)
#	@$(CC.$(ARCH)) $(CFLAGS) $(OBJS) -o $@

$(BUILD_DIR)/$(BIN.$(ARCH)): $(SRCS)
	@mkdir -p $(BUILD_DIR)/$(ARCH)
	@$(CC.$(ARCH)) $(SRCS) -o $@ $(CFLAGS)


#x86_64:
#	@mkdir -p $(BUILD_DIR)
#	@$(CC) -o $(BUILD_DIR)/$(BIN_BASE_NAME)_$@ $(SRCS) $(CFLAGS)
#	@echo $(BIN_BASE_NAME)_$@


# Compile each source file into an object file
#$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
#	@mkdir -p $(BUILD_DIR)
#	$(CC) $(CFLAGS) -c $< -o $@


#clean:
#	rm -rf $(BUILD_DIR)
#
#.PHONY:	all


