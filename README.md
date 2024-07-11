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

# Compiling on Debian
1. Install Dependencies
   * ```shell
      sudo sudo apt-get install libxrandr-dev libxcb1-dev libxcb-randr0-dev 
     ```
2. Build
   * ```shell
     make 
     ```

## Cross Compiling with Docker on Debian
1. Install Docker
   * ```shell
      sudo apt-get install docker.io 
      ```
2. Build
   * ```shell
     sudo make all-docker
     ```

## Cross Compiling Local on Debian

1. Add Architectures
   * ```shell
      sudo dpkg --add-architecture amd64  
      sudo dpkg --add-architecture i386   
      sudo dpkg --add-architecture arm64  
      sudo dpkg --add-architecture armhf  
      sudo dpkg --add-architecture armel  
      sudo dpkg --add-architecture mips64el  
      sudo dpkg --add-architecture mipsel  
      sudo dpkg --add-architecture ppc64el
      sudo dpkg --add-architecture s390x  
      ```
2. Install Dependencies
   * ```shell
      sudo apt-get install gcc
      sudo apt-get install gcc-i686-linux-gnu  
      sudo apt-get install gcc-aarch64-linux-gnu
      sudo apt-get install gcc-arm-linux-gnueabihf 
      sudo apt-get install gcc-arm-linux-gnueabi
      sudo apt-get install gcc-mips64el-linux-gnuabi64
      sudo apt-get install gcc-mipsel-linux-gnu
      sudo apt-get install gcc-powerpc64le-linux-gnu
      sudo apt-get install gcc-s390x-linux-gnu
   
      sudo apt-get install libxrandr-dev:* libxcb1-dev:* libxcb-randr0-dev:*  
      ```
3. Build
   *  ```shell
      make all
      ```



