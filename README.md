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

# Build

1. Install dependencies: `sudo apt-get install libxcb1-dev libxcb-randr0-dev cmake`
2. Build cmake project `cmake -G "Unix Makefiles" -B build .`
3. Build binary `cd build && make`


