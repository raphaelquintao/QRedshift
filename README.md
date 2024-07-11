QRedshift
===
A linux terminal application that change screen color temperature.

## Cinnamon Applet

If you're looking for the cinnamon applet the repository was renamed
to [QRedshiftCinnamon](https://github.com/raphaelquintao/QRedshiftCinnamon).

# Features

- [x] X11 Support
- [ ] Wayland Support
- [ ] Different settings for each monitor

# Usage

Basic: `qredshift -t [temperature in Kelvin] -b [bright] -g [gamma]`

Reset: `qredshift -t`

| Parameter | Description                |
|-----------|----------------------------|
| -h        | Display this help          |
| -v        | Show program version       |
| -i        | Show display info          |
| -t 6500   | Temperature in kelvin      |
| -b 1.0    | Brightness from 0.1 to 1.0 |
| -g 1.0    | Gamma from 0.1 to 1.0      |

# Compiling
1. Install dependencies
   * ```shell
      sudo apt-get install libxcb1-dev libxcb-randr0-dev
     ```
2. Build cmake project `cmake -G "Unix Makefiles" -B build .`
3. Build binary `cd build && make`

## Cross Compiling Local (DEBIAN)
**Not tested on Ubuntu**

1. Add archtetures
   ```shell
   sudo dpkg --add-architecture amd64  
   sudo dpkg --add-architecture i386   
   sudo dpkg --add-architecture armhf  
   sudo dpkg --add-architecture arm64  
   sudo dpkg --add-architecture ppc64el
   sudo dpkg --add-architecture s390x  
   ```
2. Install dependencies
   ```shell
   sudo apt-get install libxcb1-dev:amd64 libxcb-randr0-dev:amd64 libxcb1-dev:i386 libxcb-randr0-dev:i386 libxcb1-dev:armhf libxcb-randr0-dev:armhf libxcb1-dev:arm64 libxcb-randr0-dev:arm64 libxcb1-dev:ppc64el libxcb-randr0-dev:ppc64el libxcb1-dev:s390x libxcb-randr0-dev:s390x  
   ```
3. Build
   ```shell
   make all
   ```


## Cross Compiling Docker
 Todo



