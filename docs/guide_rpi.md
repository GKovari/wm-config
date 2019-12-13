# Installing wm-config on a RPi

<!-- MarkdownTOC -->

1.  [Flashing Raspbian](#flashing-raspbian)
2.  [Creating the custom.env file](#creating-the-customenv-file)
3.  [Cloning and installing wm-config](#cloning-and-installing-wm-config)
4.  [Executing wm-config](#executing-wm-config)
5.  [Disabling password based logins](#disabling-password-based-logins)

<!-- /MarkdownTOC -->

These steps require that you have physical access to:

1.  Raspberry Pi (RPi) with power and sdcard;
2.  Desktop or laptop capable of resolving mDNS or avahi services;
3.  (If 2. is not available) Keyboard and display attached to RPi.

The guide will assume that you are connecting to the RPi through the
network instead of using a keyboard and display attached to the RPi. It
also assumes you have Linux available on your desktop or laptop.

## Flashing Raspbian

We recommend a headless installation of Raspbian since there is no
need to have a full fledge GUI for the purpose of running the gateway
services.

You can get the Raspbian image from the [official Raspberry Pi foundation
website][link_raspbian].

Once the download completes, flash the sdcard that you will be using with
the RPi. We recommend using
[etcher for flashing][link_etcher].

After the flashing completes, enable ssh access by dropping an empty
file named ssh inside the sdcard's /boot partition.

Place the sdcard in the RPi, connect the ethernet cable and power it up.

On your general purpose computer, open a terminal and verify that
you can ssh into the RPi with:

```bash
   ssh pi@raspberrypi.local
```

If it does not work, ensure that you can see its advertisements using
the avahi browse:

```bash
   avahi-browse -a
```

If the problem persist, please check your that you have copied the file
to the boot sector and that you are under the same network as your device.
At this point you should consider connecting a display to your RPi to view
the IP printed at the end of the boot sequence or
[configure your RPi image prior to flashing][https://www.pibakery.org/].

## Creating the custom.env file

Before you continue throughout this section, please ensure that you have
a MQTT broker running and that you can reach it from your network. There
is no requirement from the gateway's point of view regarding which broker
to use, as long as it supports MQTT version 3.1.

We will now create a custom.env file that will tell the gateway to send
data to your MQTT broker.

Let's assume the following details about your MQTT broker:

-   **hostname:** mqttbroker.atmydomain.com
-   **username:** mqttuser
-   **password:** mqttuserpassword
-   **port:** 8883 (secure) and 1883 (unsecure)

Open a text editor and copy the following settings:

```yaml
   ---
   # MQTT location
   WM_SERVICES_MQTT_HOSTNAME=mqttbroker.atmydomain.com

   # MQTT credentials
   WM_SERVICES_MQTT_USERNAME=mqttuser
   WM_SERVICES_MQTT_PASSWORD=mqttuserpassword
   WM_SERVICES_MQTT_PORT=8883
```

Next we set the gateway version by appending the following information to
the file:

```yaml
   # Wirepas Linux (dbus) Gateway
   # Uncomment and set the following keys to specify the gateway build version
   WM_GW_VERSION=v1.2.0
   WM_GW_IMAGE=wirepas/gateway
```

As a last step we change the RPi hostname from the default
hostname, *raspberry*, to  a custom one, *wm-config-rpi*.

We do so by appending the following information file:

```yaml
   # Raspi settings
   WM_HOST_HOSTNAME="myrpi"
```

After these steps, your text editor should contain the following information:

```yaml
   ---
   # MQTT location
   WM_SERVICES_MQTT_HOSTNAME=mqttbroker.atmydomain.com

   # MQTT credentials
   WM_SERVICES_MQTT_USERNAME=mqttuser
   WM_SERVICES_MQTT_PASSWORD=mqttuserpassword
   WM_SERVICES_MQTT_PORT=8883

   # Wirepas Linux (dbus) Gateway
   # Uncomment and set the following keys to specify the gateway build version
   WM_GW_VERSION=v1.2.0
   WM_GW_IMAGE=wirepas/gateway

   # If you want to use port 1883 please uncomment the following lines
   # WM_SERVICES_MQTT_PORT=1883
   # WM_SERVICES_ALLOW_UNSECURE=true

   # Raspi settings
   WM_HOST_HOSTNAME="myrpi"
```

Save it under your filesystem, eg, under *~/custom.env*.

As an alternative, you can use the installation scripts interactive mode
to create a minimal configuration file:

```bash
   setup.sh --interactive 
```

## Cloning and installing wm-config

Now we will move on to the framework installation. We will follow the
same steps as outlined in the main README file. We opt to build an archive
instead of cloning the repository within the RPi.

If you have not done it yet, clone the wm-config repository in your
local machine with:

```bash
   git clone https://github.com/wirepas/wm-config.git
```

Run the packing command as described in the README file:

```bash
   ./setup.sh --pack
```

As instructed, copy the files to your RPi (which still has Raspbian's default
username and password). We do it with the following steps:

```bash
   scp ./deliverable/wm-config.tar.gz pi@raspberrypi.local:
   scp ./setup.sh pi@raspberrypi.local:
   scp ~/.custom.env pi@raspberrypi.local:
```

With the files in your RPi, the next step is to ssh inside it and install
wm-config.

```bash
   ssh pi@raspberrypi.local
   ./setup.sh --skip-call
```

The installation of wm-config is now complete.

## Executing wm-config

Call wm-config (from any directory) to start the 
installation on your RPi:

```bash
   wm-config
```

Once wm-config starts running it will start by making a few modifications
to your RPi, such as setting the hostname, installing packets and rebooting
when it is necessary.

You can follow the progress and status of the installation in your terminal
but once it reboots you will have to use the journalctl to observe
what the program is doing in the background.

To do so, use the following command:

```bash
   journalctl -uf wirepas-updater.service
```

It will show and follow wm-config's output.

After all is installed you should observe that your device is now reachable
through it new hostname:

```bash
   ssh pi@myrpi.local
```

The gateway services should also be up and running. 

Through wm-config:

```bash
   wm-config --status
```

 or through the docker daemon:

```bash
   docker ps
```

## Disabling password based logins

Leaving a RPi with the default password on is not a good idea.

We recommend that you use public private key pairs, change the default
password and disable password based ssh logins.

For your convenience, all of these steps can be done automatically using
wm-config and its configuration file.

Start by locating the public key that you want to use to access the
RPi or
[create a new private public key pair](https://linux.die.net/man/1/ssh-keygen).

Assuming your public key is located under *~/.ssh/mykey.pub*,
copy it inside your RPi with the following command:

```bash
   scp *~/.ssh/mykey.pub* pi@myrpi.local:
```

Log in to your RPi and update the custom.env file with the following command:

```bash
   ssh pi@myrpi.local
   sudo cp /boot/wirepas/custom.env .
   cat ./mykey.pub | awk -F "\n" '{print "WM_HOST_USER_PPKI="$1}' >> custom.env
```

Before we call wm-config to apply the changes, let's also take the time
to update the password and disable plain text login with ssh.

Add the following keys to the local copy of the custom.env:

```bash
   echo "WM_HOST_SSH_ENABLE_PASSWORD_LOGIN=true" >> ./custom.env
   echo "WM_HOST_USER_PASSWORD=mypassword" >> ./custom.env
```

Now copy the file back and call wm-config to apply the changes:

```bash
   sudo mv custom.env /boot/wirepas/custom.env
   wm-config
```

After wm-config runs, your password and ssh daemon settings will have been
changed. Confirm it by accessing the RPi with the private key:

```bash
   ssh -i ~/.ssh/mykey pi@myrpi.local
```

Remember, that all of these changes can be done by mounting the RPi
sdcard on your desktop or laptop machine.

[link_raspbian]: https://www.raspberrypi.org/downloads/raspbian/

[link_etcher]: https://www.balena.io/etcher/
