## QRedshift

A linux lightweight terminal application to change screen color temperature.

### Cinnamon Applet

If you're looking for the cinnamon applet the repository was renamed to [QRedshiftCinnamon](https://github.com/raphaelquintao/QRedshiftCinnamon).

## Features

- [x] X11 Support
- [ ] Different settings for each monitor
- [ ] Wayland Support (Not possible for Cinnamon/Muffin and Gnome/ Mutter)

## Usage

Basic: `qredshift -t [temperature in Kelvin] -b [bright] -g [gamma]`

Reset: `qredshift -t`

| Parameter | Description                |
|-----------|----------------------------|
| `-h`      | Display this help          |
| `-v`      | Show program version       |
| `-i`      | Show display info          |
| `-t` 6500 | Temperature in kelvin      |
| `-b` 1.0  | Brightness from 0.1 to 1.0 |
| `-g` 1.0  | Gamma from 0.1 to 1.0      |
| `-xlib`   | Use Xlib instead of XCB    |

<details>
   <summary><b>Xlib and XCB</b></summary>

* **Xlib** is the traditional, higher-level, and synchronous C library for interacting with the X Window System. It has been the standard for a long time but can be slower due to its synchronous nature.
* **XCB** (X C Binding) is a more modern, lower-level, and asynchronous replacement for Xlib. It allows for better performance by reducing round-trips to the X server and enabling parallel request processing.
* See: [The X New Developer's Guide: Xlib and XCB](https://www.x.org/wiki/guide/xlib-and-xcb/)

</details>

## Compiling

###### Debian
```shell
sudo apt-get install libxrandr-dev libxcb1-dev libxcb-randr0-dev
make
```

###### Arch

```shell
sudo pacman -Syu libxrandr libxcb xcb-util
make
```

### Cross Compiling

###### Debian
```shell
sudo apt-get install docker.io 
sudo make docker
```

###### Arch

```shell
sudo pacman -Syu docker
sudo make docker
```



