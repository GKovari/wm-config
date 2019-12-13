# WM Config

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d0cc4a802858493e94a72165e1da1c5c)](https://www.codacy.com/manual/wirepas/wm-config?utm_source=github.com&utm_medium=referral&utm_content=wirepas/wm-config&utm_campaign=Badge_Grade)

<!-- MarkdownTOC  autolink="true" levels="1,2" -->

-   [Requirements](#requirements)
-   [Customizing wm-config - creating a custom.env file](#customizing-wm-config---creating-a-customenv-file)
-   [Installation](#installation)
-   [Inspecting the services status](#inspecting-the-services-status)
-   [Guides](#guides)
-   [Q&A](#qa)
-   [Contributing](#contributing)
-   [License](#license)

<!-- /MarkdownTOC -->

The Wirepas Host Configurator (wm-config)
is a [bash utility][here_bin_wmconfig]
which effortlessly configures your host computer
with the Wirepas gateway software.

WM-CONFIG relies on the Docker engine to setup the gateway services.
**Figure 1** provides a quick glance of the utility's place in the
host environment and a short overview of its operation.

![runtime operation of wm-config][here_img_overview]

**Figure 1:** provides an overview of the steps taken by wm-config.

After its installation the utility is meant to be summoned
anywhere by typing:

```bash
   wm-config [--help]
```

As depicted in **Figure 1**, wm-config starts by sourcing
the bash modules (see [/modules][here_modules]) and the settings file.

There are two settings file, one that contains the [default values for
the parameters][here_environment_default] and one that is create by
you which
[overloads the settings to meet your needs][here_environment_custom].

Once the evaluation of the files is done, wm-config will
install any dependencies in your host, generate the
composition files and start the gateway services.

Under a Raspberry Pi (RPi), wm-config will by default change
several host settings, including hostname, ssh authorized
keys, WiFi AP client settings, among others.

For non-RPi hosts, wm-config is restricted on its operations,
which consist of setting up symlinks for the tty ports and
installing system dependencies. You can customize the behavior based on
your needs by enabling and disabling certain features
within your custom.env file. Please refer to the
[documentation][here_settings_list] and
[feature.env][here_feature_enable] for a list of available features.

## Requirements

This framework requires a debian based distribution in order to
function properly.

Dependencies needed by the tool are automatically installed if
you allow it to do do.

<!-- auto_start -->

## Customizing wm-config - creating a custom.env file

The wm-config utility is highly configurable through a single environment file. The
environment file is sourced based on the path defined with
[**WM_CFG_SETTINGS_CUSTOM**][here_settings_custom].

The custom.env file overrides the default values present in the default settings file
distributed with a given version of the framework. You should never change the default values unless you
know what you are doing.

The environment keys that define the custom file location and store the framework version are:

-   **WM_CFG_VERSION** : Current WM-CONFIG version in use

-   **WM_CFG_SETTINGS_CUSTOM**  : Path to the custom settings file

Besides knowing where the custom settings are loaded from, it is very important for you to
understand how you can control where to publish data and which version of the gateway you are running.

The keys that allow you to change such behaviour are the following ones:

| **Key**                             | **Description and default value**                                                                      |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------ |
| **WM_GW_IMAGE**                     | The name of the WM Gateway Docker image to pull  (_default=wirepas/gateway_)                           |
| **WM_GW_VERSION**                   | The build or docker tag to use (_default=latest_)                                                      |
| _MQTT hostname and credentials_     |                                                                                                        |
| **WM_SERVICES_MQTT_HOSTNAME**       | A host where to push the gateway data, eg, MQTT broker hostname or ip  (_default=host.extwirepas.com_) |
| **WM_SERVICES_MQTT_USERNAME**       | The MQTT username (_default=mqttuser_)                                                                 |
| **WM_SERVICES_MQTT_PASSWORD**       | The MQTT's username password corresponding (_default=uiaidujfk1897fyeu023849sdh?(_)                    |
| **WM_SERVICES_MQTT_PORT**           | Defines the MQTT port to use (unsecure 1883, secure 8883) (_default=8883_)                             |
| **WM_SERVICES_MQTT_ALLOW_UNSECURE** | Must be set to true to allow unsecure connections, eg, to port 1883 (_default=unset_)                  |

When using a Raspberry Pi, it is useful to set a unique hostname to allow easy ssh through the advertised avahi name.
Besides that, you can also enable and disable password based access as well as private public key based access.

Here are the keys for such purpose:

| **Key**                               | **Description and default value**                                        |
| ------------------------------------- | ------------------------------------------------------------------------ |
| **WM_HOST_HOSTNAME**                  | Sets the hostname of the host (_default=wm-evk_)                         |
| **WM_HOST_USER_PPKI**                 | The public key to authorize in the ssh authorized keys (_default=unset_) |
| **WM_HOST_SSH_ENABLE_PASSWORD_LOGIN** | Enables ssh login using plain text passwords (_default=true_)            |

Please refer to [environment/custom.env][here_environment_custom] for an example on how to define a custom.env file.

A full list of keys is available from [docs/settings.md][here_settings_list].

<!-- auto_end -->

## Installation

You can chose to install directly from github or from an archive.

### Installing from github

Clone this repository, checkout [a release tag][here_releases] and run:

```bash
   ./setup.sh --skip-call
```

The repository files will be copied under
[WM_CFG_INSTALL_PATH][here_bin_wmconfig].

Copy your custom.env file to the path specified in
[WM_CFG_SETTINGS_CUSTOM][here_settings_custom]
and call the utility with:

```bash
   wm-config
```

### Creating and installing from an archive

An archive bundle is useful to share across multiple hosts
without having to install and clone the repository N times.

To build an archive, clone the repository on a machine
with bash and run the following script:

```bash
   ./setup.sh --pack
```

An archive will be created under ./deliverable/wm-config.tar.gz\_.

Copy the following files to the host where you want to perform
the installation:

-   ./deliverable/wm-config.tar.gz
-   setup.sh
-   custom.env

Once the copy is complete, login in the device and call
setup.sh. The script will extract the files, copy them
to [WM_CFG_INSTALL_PATH][here_bin_wmconfig] and
call wm-config.

As an example, let's assume your user is _someuser_
and the machine where you want to install wm-config
is known in your network with IP 192.168.1.10.

To copy the files you would type:

```bash
   scp ./deliverable/wm-config.tar.gz someuser@192.168.1.10:
   scp ./setup.sh someuser@192.168.1.10:
   scp ~/custom.env someuser@192.168.1.10:

   ssh someuser@192.168.1.10
   ./setup.sh
```

:warning:

_To successfully run the commands, set the correct
user name and the correct IP or host name for your
target machine._

## Inspecting the services status

To inspect the status of the gateway services type:

```bash
   wm-config --status
```

The utility will show you the latest logs from the sink and
transport service.

Alternatively, you can view the logs yourself through the docker
engine or docker compose.

With plain docker commands, type:

```bash
   docker ps : to view the status of the services

   docker logs <container name>
```

With docker compose either change
directory to [WM_CFG_INSTALL_PATH][here_bin_wmconfig]
or provide the path to the compose file with the _-f_ switch :

```bash
   docker-compose [ -f $WM_CFG_INSTALL_PATH/lxgw/docker-compose.yml ] ps

   docker-compose [ -f $WM_CFG_INSTALL_PATH/lxgw/docker-compose.yml ] logs
```

If you wish to stop the services type:

```bash
   wm-config --state stop
```

To resume operation type:

```bash
   wm-config --state start
```

For other arguments, please review the help output with:

```bash
   wm-config --help
```

## Guides

[How to prepare a RPi with wm-config][here_guide_rpi_setup]

## Q&A

### What are the differences or reasons for wm-config v2?

In version 1 of wm-config we had quite a lot of logic to handle different
gateway prototypes that we had been experimenting with.

Since most of these projects are no longer active, we wanted to clean
up wm-config in order to keep it easier to maintain going forward. Our
goal is to simplify the usage of the framework and still allow you
to customize its behavior in order to fit your particular needs.

We have also merged functionality within scripts, such as packing
and interactive generation of settings. You will now find all of
this available under the setup.sh script.

### Can I still use v1 with upcoming Wirepas Gateway releases?

Yes you can! This ought to be possible with upcoming gateway releases
under the version 1 major number. Once the major changes, it is
likely that we will introduce changes to the environment keys.

At that point you will have to customize the templates accordingly
or move to wm-config v2.

### How do I upgrade from wm-config v1?

Start by backing up or saving your custom.env file in a place that
does not fall within any of the framework folders.

Afterwards, you must ensure the removal of:

-   wm-config entrypoint (_./local/bin/wm-config or /usr/local/bin/wm-config_)
-   wm-config modules (_~/wirepas/wm-config_)

Doing so requires that you do each of these steps manually or that you call
wm-config v2.0.0's installation script:

```bash
    setup.sh --uninstall
```

Afterwards, clone the repository or copy the bundle for v2.0.0 under your home
folder. Make a copy of your old v1 custom.env and update its key to match
the new names under v2. Move the custom.env file under your home folder.

Call the setup script to complete the installation of version 2.

### What keys have changed between v1 and v2?

We have done a major restructuring in the key names. There are still a few names
that remain, but the majority has changed. We have tried to harmonize the names
in order to make them more sensible and memorable.

Some of these changes will be coherent with other Wirepas projects, making our
tools easier to use and configure.

## Contributing

Please read contribution guidelines from [CONTRIBUTING.md][here_contributing].

## License

Licensed under the Apache License, Version 2.0.
See [LICENSE][here_license] for the full license text.

[here_bin_wmconfig]: ./bin/wm-config.sh

[here_environment_custom]: ./environment/custom.env

[here_environment_default]: ./environment/default.env

[here_feature_enable]: ./environment/feature.env

[here_modules]: ./modules

[here_img_overview]: ./docs/img/overview.png

[here_guide_rpi_setup]: ./docs/guide_rpi.md

[here_settings_custom]: ./environment/path.env

[here_settings_list]: ./docs/settings.md

[here_releases]: https://github.com/wirepas/wm-config/releases

[here_contributing]: https://github.com/wirepas/wm-config/blob/master/CONTRIBUTING.md

[here_license]: https://github.com/wirepas/wm-config/blob/master/LICENSE
