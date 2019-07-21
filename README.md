# Kubuntu 19.04 on a Dell Inspiron 7559? Done!

This is a short guide that helps install Kubuntu on a machine that's known for causing nothing but trouble with Linux installations.


## Installation

To start installing Kubuntu, follow these steps:

 * Download Kubuntu 19.04 and prepare an installation media for the same.
 * Make sure that you've disabled Secure Boot from inside your BIOS.
 * Boot from your media containing Kubuntu 19.04.
 * Select the boot entry with the label `Start Ubuntu`, but do not press ENTER.
 * Now press `e` to edit the entry.
 * Find the line that specifies the boot parameters. It looks something like this:

```
linux /casper/vmlinuz .....
```

 * Find the portion `quiet splash` and replace it with this:


```
nomodeset i915_bpo.nomodeset=1
```

 * Now press Ctrl+X or F10 to boot.
 * Next, when you are prompted with the choice of installing or trying Kubuntu, directly install Kubuntu.
 * While installing Kubuntu, do not tick the checkbox 'Install third-party software and drivers'.
 * After installation, you will be prompted to remove the installation media and press ENTER, which will lead you to a reboot.


## Configuration

 * After rebooting, you'll be presented with the GRUB boot menu, from which you have to select the Kubuntu installation, then press `e`.
 * Find the line that specifies the boot parameters. It looks something like this:

```
linux /casper/vmlinuz .....
```

 * Find the portion `quiet splash` and replace it with this:


```
nomodeset i915_bpo.nomodeset=1
```

 * Press Ctrl+X or F10 to boot.
 * Upon booting, you'll see that the login screen never gets displayed. This is because the drivers are not yet installed.
 * Press Ctrl+Alt+F2 to drop into another login shell.
 * Enter your credentials and log in.
 * Next, update your package lists using the command:

```
sudo apt update
```

 * Then, install Git with the command:

```
sudo apt install git
```

 * Now, clone this repository and enter the directory with the command:

```
git clone https://github.com/nocturnalbeast/kubuntu-19.04-inspiron-7559-setup && cd kubuntu-19.04-inspiron-7559-setup
```

 * Make the setup script executable with the command:

```
chmod +x setup.sh
```

 * Now run the command to see the options:

```
./setup.sh --help
```

 * Now run these commands in succession:

```
./setup.sh --update
./setup.sh --install
./setup.sh --fixdpi
```

 * This will upgrade the system packages, install the drivers for the NVIDIA GPU, and then drop in configuration files for KDE to fix scaling issues.


## Extras

This script also has a helper to quickly install a bunch of applications, fonts and themes.

Run the script with the option `--tools` like so:

```
./setup.sh --tools
```

to install these.