# List of settings

The following tables contain the full set of environmental
keys used by wm-config:

<!-- MarkdownTOC -->

- [Host and dependency management](#host-and-dependency-management)
- [Gateway and data broker settings](#gateway-and-data-broker-settings)
- [Framework feature selection](#framework-feature-selection)

<!-- /MarkdownTOC -->

With the exception of the discovered and static variables,
all the variables are found from
the [default settings file][here_environment_default].

Please understand that certain settings might break
the functionality of the services
and alter the state of your host.

We aim to prevent major issues by reducing
the amount of features enabled
by default in hosts other than a RPi.

You can control and review which features are enabled
under your host by looking at the
[feature.env file][here_environment_feature].
If you wish to change the default value, please do it
so under your custom.env file.

## Host and dependency management

| *WM-CONFIG discovered variables*          | *Description*                                                                                                                                                                                           |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **WM_CFG_HOST_ARCH**                      | Host architecture                                                                                                                                                                                       |
| **WM_CFG_HOST_MODEL**                     | Host model                                                                                                                                                                                              |
| **WM_CFG_HOST_IS_RPI**                    | True when running on a RPi                                                                                                                                                                              |
| ---                                       | ---                                                                                                                                                                                                     |
| *WM-CONFIG static variables*              |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| **WM_CFG_VERSION**                        | Current WM-CONFIG version in use                                                                                                                                                                        |
| **WM_CFG_ENTRYPOINT**                     | Path where to copy the shell entrypoint (./bin/wm-config.sh) ('default:${HOME}/.local/bin/wm-config')                                                                                                   |
| **WM_CFG_INSTALL_PATH**                   | Directory where wm-config files will be copied to (default: '${HOME}/.local/wirepas/wm-config')                                                                                                         |
| **WM_CFG_SETTINGS_PATH**                  | Path where settings will be sourced from (default: /boot/wirepas for RPi and '${HOME}/wirepas/wm-config' for others )                                                                                   |
| **WM_CFG_SETTINGS_DEFAULT**               | Path to the default settings (default: '${WM_CFG_SETTINGS_PATH}/default.env')                                                                                                                           |
| **WM_CFG_SETTINGS_CUSTOM**                | Path to the user settings (default: '${WM_CFG_SETTINGS_PATH}/custom.env')                                                                                                                               |
| **WM_CFG_HOST_DEPENDENCIES_PATH**         | Path with files that will be copied to the host environment and dependency description (default: '${WM_CFG_INSTALL_PATH}/host')                                                                         |
| **WM_CFG_UPDATE_PATH**                    | Path used by the container to copy updated files (default: '${WM_CFG_INSTALL_PATH}/update')                                                                                                             |
| **WM_CFG_TEMPLATE_PATH**                  | Path where to lookup template files. The templates are files that will be generated based on the current host's environment (default: '${WM_CFG_INSTALL_PATH}/templates')                               |
| **WM_CFG_SESSION_STORAGE_PATH**           | Path where session logs are stored to (default: '${WM_CFG_SETTINGS_PATH}/.session')                                                                                                                     |
| ---                                       | ---                                                                                                                                                                                                     |
| *WM-CONFIG runtime configuration*         |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| ##WM_HOST_INSTALL_DEPENDENCIES            | When *true* the wm-config will run (if present) ${WM_CFG_HOST_DEPENDENCIES_PATH}/host_requiremens.sh and ${WM_CFG_HOST_DEPENDENCIES_PATH}/requirements.txt (##WM_CFG_HOST_INSTALL_DEPENDENCIES_DEFAULT) |
| ##WM_HOST_UPGRADE_PACKAGES                | When *true* the wm-config will ensure all host packages are upgraded (##WM_CFG_HOST_UPGRADE_DEFAULT)                                                                                                    |
| ##WM_CFG_STARTUP_DELAY                    | Sets the amount of seconds to delay the execution of wm-config (##WM_CFG_STARTUP_DELAY_DEFAULT)                                                                                                         |
| ##WM_CFG_REBOOT_DELAY                     | Sets the amount of seconds to wait before taking an action, such as a status report (##WM_CFG_REBOOT_DELAY_DEFAULT)                                                                                     |
| ##WM_CFG_PYTHON_VERSION                   | Python version to use when creating the virtual environment (##WM_CFG_PYTHON_VERSION_DEFAULT)                                                                                                           |
| ##WM_CFG_PYTHON_VIRTUAL_ENV               | Path where to create or find the python virtual environment where to install the wm-config dependencies (##WM_CFG_PYTHON_VIRTUAL_ENV_DEFAULT)                                                           |
| ##WM_CFG_WEBHOOK_POST_URL                 | A webhook where to post information about the wm-config execution (##WM_CFG_WEBHOOK_POST_URL_DEFAULT)                                                                                                   |
| ---                                       | ---                                                                                                                                                                                                     |
| *WM-CONFIG updater*                       | ---                                                                                                                                                                                                     |
| ---                                       | ---                                                                                                                                                                                                     |
| ##WM_CFG_FRAMEWORK_UPDATE                 | When *true* the wm-config will pull an update image for the framework files (##WM_CFG_FRAMEWORK_UPDATE_DEFAULT)                                                                                         |
| ##WM_CFG_UPDATER_VERSION                  | The wm-config release version to pull - image's tag  (##WM_CFG_UPDATER_VERSION_DEFAULT)                                                                                                                 |
| ##WM_CFG_UPDATER_IMAGE                    | The registry and name of the docker image containing the wm-config files (##WM_CFG_UPDATER_IMAGE_DEFAULT)                                                                                               |
| ---                                       | ---                                                                                                                                                                                                     |
| *Docker daemon configuration*             |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| ##WM_DOCKER_STATUS_DELAY                  | The amount of seconds to wait before displaying the gateway service status (##WM_DOCKER_STATUS_DELAY_DEFAULT)                                                                                           |
| ##WM_DOCKER_USERNAME                      | The user name to use when logging in with Docker (##WM_DOCKER_USERNAME_DEFAULT)                                                                                                                         |
| ##WM_DOCKER_PASSWORD                      | The user's password to use when logging in with docker (##WM_DOCKER_PASSWORD_DEFAULT)                                                                                                                   |
| ##WM_DOCKER_DAEMON_JSON                   | **Advanced** The JSON text to configure the docker daemon with (##WM_DOCKER_DAEMON_JSON_DEFAULT)                                                                                                        |
| ##WM_DOCKER_CLEANUP                       | Forces a cleanup of all running docker containers and performs a system prune  (##WM_DOCKER_CLEANUP_DEFAULT)                                                                                            |
| ##WM_DOCKER_FORCE_RECREATE                | Ensures that containers are recreated whenever the services state is monitored (##WM_DOCKER_FORCE_RECREATE_DEFAULT)                                                                                     |
| ---                                       | ---                                                                                                                                                                                                     |
| *Filesystem and access control*           |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| **WM_HOST_FILESYSTEM_MANAGEMENT**         | When true expands the filesystem  (default: false (x86), true (raspi))                                                                                                                                  |
| ##WM_HOST_HOSTNAME                        | Sets the hostname of the host (##WM_HOST_SET_HOSTNAME_DEFAULT)                                                                                                                                          |
| ##WM_HOST_USER_NAME                       | The username of the host's admin user (##WM_HOST_USER_NAME_DEFAULT)                                                                                                                                     |
| ##WM_HOST_USER_PASSWORD                   | The password of the host's admin user (##WM_HOST_USER_PASSWORD_DEFAULT)                                                                                                                                 |
| ##WM_HOST_USER_PPKI                       | The public key to authorize in the ssh authorized keys (##WM_HOST_USER_PPKI_DEFAULT)                                                                                                                    |
| ##WM_HOST_SSH_ENABLE_PASSWORD_LOGIN       | Enables ssh login using plain text passwords (##WM_HOST_SSH_ENABLE_PASSWORD_LOGIN_DEFAULT)                                                                                                              |
| ---                                       | ---                                                                                                                                                                                                     |
| *Periodic job control (requires systemd)* |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| ##WM_SYSTEMD_UPDATER                      | The name of the systemd job that monitors the wm-config state (##WM_SYSTEMD_UPDATER_DEFAULT)                                                                                                            |
| ##WM_SYSTEMD_UPDATER_INTERVAL             | (##WM_SYSTEMD_UPDATER_INTERVAL_DEFAULT)                                                                                                                                                                 |
| ##WM_SYSTEMD_UPDATER_ENABLE               | When *true* the systemd job will be enabled and started (##WM_SYSTEMD_UPDATER_ENABLE_DEFAULT)                                                                                                           |
| ##WM_SYSTEMD_UPDATER_DISABLE              | When *true* the systemd job will be disabled (##WM_SYSTEMD_UPDATER_DISABLE_DEFAULT)                                                                                                                     |
| ---                                       | ---                                                                                                                                                                                                     |
| *Internet connectivity*                   |                                                                                                                                                                                                         |
| ---                                       | ----                                                                                                                                                                                                    |
| **WM_HOST_BLACKLIST_IPV6**                | Blacklists the IPv6 module and reboots the host (default=false (x86), true (raspi))                                                                                                                     |
| ##WM_WIFI_ENABLE                          | When true forces the WiFi interface to be down  (##WM_WIFI_DISABLE_DEFAULT)                                                                                                                             |
| ##WM_WIFI_AP_SSID                         | The WiFi SSID where the host should connect to (##WM_WIFI_AP_SSID_DEFAULT)                                                                                                                              |
| ##WM_WIFI_AP_PASSWORD                     | The WiFi's SSID password (##WM_WIFI_AP_PASSWORD_DEFAULT)                                                                                                                                                |
| ---                                       | ---                                                                                                                                                                                                     |
| *For Wirepas support*                     |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| ##WM_SUPPORT_PORT                         | For Wirepas support (##WM_SUPPORT_PORT_DEFAULT)                                                                                                                                                         |
| ##WM_SUPPORT_HOSTNAME                     | For Wirepas support (##WM_SUPPORT_HOSTNAME_DEFAULT)                                                                                                                                                     |
| ##WM_SUPPORT_KEY                          | For Wirepas support (##WM_SUPPORT_KEY_DEFAULT)                                                                                                                                                          |
| ##WM_SUPPORT_USERNAME                     | For Wirepas support (##WM_SUPPORT_USERNAME_DEFAULT)                                                                                                                                                     |
| ##WM_SUPPORT_KEY_PATH                     | For Wirepas support (##WM_SUPPORT_KEY_PATH_DEFAULT)                                                                                                                                                     |
| ---                                       | ---                                                                                                                                                                                                     |
| *Keyboard settings*                       |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| ##WM_HOST_KEYBOARD_CONFIGURE              | Sets the host's keyboard (##WM_HOST_SET_KEYBOARD_DEFAULT)                                                                                                                                               |
| ##WM_HOST_KEYBOARD_XKBMODEL               | Defines the host's keyboard model (##WM_HOST_KEYBOARD_XKBMODEL_DEFAULT)                                                                                                                                 |
| ##WM_HOST_KEYBOARD_BACKSPACE              | Defines the host's keyboard backspace (##WM_HOST_KEYBOARD_BACKSPACE_DEFAULT)                                                                                                                            |
| ##WM_HOST_KEYBOARD_XKBOPTIONS             | Defines the host's keyboard options (##WM_HOST_KEYBOARD_XKBOPTIONS_DEFAULT)                                                                                                                             |
| ##WM_HOST_KEYBOARD_XKBLAYOUT              | Defines the host's keyboard layout (##WM_HOST_KEYBOARD_XKBLAYOUT_DEFAULT)                                                                                                                               |
| ##WM_HOST_KEYBOARD_XKBVARIANT             | Defines the host's keyboard variant (##WM_HOST_KEYBOARD_XKBVARIANT_DEFAULT)                                                                                                                             |
| **WM_HOST_AVAHI_DAEMON_MANAGEMENT**       | Where to source avahi services from (default=false (x86), true (raspi))                                                                                                                                 |

## Gateway and data broker settings

| *MQTT broker settings*                         |                                                                                                                                                         |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ##WM_SERVICES_MQTT_HOSTNAME                    | A host where to push the gateway data, eg, MQTT broker hostname or ip  (##WM_SERVICES_MQTT_HOSTNAME_DEFAULT)                                            |
| ##WM_SERVICES_MQTT_USERNAME                    | The MQTT username (##WM_SERVICES_MQTT_USERNAME_DEFAULT)                                                                                                 |
| ##WM_SERVICES_MQTT_PASSWORD                    | The MQTT's username password corresponding (##WM_SERVICES_MQTT_PASSWORD_DEFAULT)                                                                        |
| ##WM_SERVICES_MQTT_PORT                        | Defines the MQTT port to use (unsecure 1883, secure 8883) (##WM_SERVICES_MQTT_PORT_DEFAULT)                                                             |
| ##WM_SERVICES_MQTT_ALLOW_UNSECURE              | Must be set to true to allow unsecure connections, eg, to port 1883 (##WM_SERVICES_MQTT_ALLOW_UNSECURE_DEFAULT)                                         |
| ##WM_SERVICES_MQTT_CERTIFICATE_CHAIN           | The container path where to find the root ca certificates (##WM_SERVICES_MQTT_CERTIFICATE_CHAIN_DEFAULT)                                                |
| ---                                            | ---                                                                                                                                                     |
| *Gateway metadata, transport and sink service* |                                                                                                                                                         |
| ---                                            | ---                                                                                                                                                     |
| ##WM_GW_STATE                                  | The state of the gateway services to enforce (start/stop) (##WM_GW_STATE_DEFAULT)                                                                       |
| ##WM_GW_ID                                     | The id used to identifying the gateway at the MQTT level (##WM_GW_ID_DEFAULT)                                                                           |
| ##WM_GW_MODEL                                  | Metadata about the gateway model (##WM_GW_MODEL_DEFAULT)                                                                                                |
| ##WM_GW_VERSION                                | Metadata about the gateway version (##WM_GW_VERSION_DEFAULT)                                                                                            |
| ##WM_GW_WHITENED_ENDPOINTS_FILTER              | List of endpoints whose payload should be zeroed out when published to the broker  (##WM_GW_WHITENED_ENDPOINTS_FILTER_DEFAULT)                          |
| ##WM_GW_IGNORED_ENDPOINTS_FILTER               | List of endpoints that should not be published to the MQTT broker (##WM_GW_IGNORED_ENDPOINTS_FILTER_DEFAULT)                                            |
| ##WM_GW_IMAGE                                  | The name of the WM Gateway Docker image to pull  (##WM_GW_IMAGE_DEFAULT)                                                                                |
| ##WM_GW_VERSION                                | The build or docker tag to use (##WM_GW_VERSION_DEFAULT)                                                                                                |
| ##WM_GW_SINK_UART_PORT                         | The port where a Wirepas sink can be found from (##WM_GW_SINK_UART_PORT_DEFAULT)                                                                        |
| ##WM_GW_SINK_ID                                | The pseudo id of the sink served by the sink service (##WM_GW_SINK_ID_DEFAULT)                                                                          |
| ##WM_GW_SERVICES_USER_PATH                     | **Advanced** The path to create and overlay within the containers (##WM_GW_SERVICES_USER_PATH_DEFAULT)                                                  |
| ##WM_GW_SERVICES_ENV_FILE                      | **Advanced** Location of the environment file used by the transport and sink service (##WM_GW_SERVICES_ENV_FILE_DEFAULT)                                |
| ##WM_GW_TRANSPORT_SERVICE_CMD                  | **Advanced** The command to use with the transport service container (##WM_GW_TRANSPORT_SERVICE_CMD_DEFAULT)                                            |
| ##WM_GW_TRANSPORT_SERVICE_NETWORK              | **Advanced** The network where to attach the transport service container (##WM_GW_TRANSPORT_SERVICE_NETWORK_DEFAULT)                                    |
| ##WM_GW_SINK_SERVICE_CMD                       | **Advanced** The command to use with the sink service container (##WM_GW_SINK_SERVICE_CMD_DEFAULT)                                                      |
| ##WM_GW_SINK_PORT_RULE                         | **Advanced** The sink ports to use during the auto enumerate (##WM_GW_SINK_PORT_RULE_DEFAULT)                                                           |
| ##WM_GW_SINK_BLACKLIST                         | **Advanced** A patter or device to ignore during the auto enumeration (##WM_GW_SINK_BLACKLIST_DEFAULT)                                                  |
| ##WM_GW_SINK_BITRATE_CONFIGURATION             | **Advanced** An array with the bitrate to use for a given sink. The sink id will match the array index (##WM_GW_SINK_BITRATE_CONFIGURATION_DEFAULT)     |
| ##WM_GW_SINK_ENUMERATION                       | **Advanced** Set to true to enable the automatic enumeration of tty ports - removes the need to specify a given port (##WM_GW_SINK_ENUMERATION_DEFAULT) |
| ##WM_GW_DBUS_CONF                              | **Advanced** The DBUS configuration file to be present in the host environment (##WM_GW_DBUS_CONF_DEFAULT)                                              |
| ##WM_GW_DBUS_CONF_USER                         | **Advanced** The user that should be set within the DBUS configuration (##WM_GW_DBUS_CONF_USER_DEFAULT)                                                 |
| ##WM_HOST_TTY_SYMLINK                          | The serial alias to associate with a Wirepas complaint device attached to the host (##WM_HOST_TTY_SYMLINK_DEFAULT)                                      |

## Framework feature selection

The feature keys enable or disable certain functionality of the framework, *regardless* of the other keys' values.

| *WM-CONFIG feature*             | *Description*                                                                                                |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **WM_HOST_REBOOT**                  | When true, reboot requests will be automatically scheduled                                                   |
| **WM_HOST_CLOCK_MANAGEMENT**        | (Requires timesyncd) When true, forces the time daemon to sync                                               |
| **WM_HOST_SYSTEMD_MANAGEMENT**      | (Requires systemd) When true, allows systemd jobs to be setup                                                |
| **WM_HOST_BLACKLIST_IPV6**          | When true, disables IPv6 on the host                                                                         |
| **WM_HOST_SSH_DAEMON_MANAGEMENT**   | When true, allows the framework to customize the ssh daemon settings and authorized keys                     |
| **WM_HOST_AVAHI_DAEMON_MANAGEMENT** | (Requires avahi) When true, advertises the ssh service under the avahi daemon                                |
| **WM_HOST_FILESYSTEM_MANAGEMENT**   | (Only affects RPi) When true, it will perform file system operations, such as expansion of the volumes       |
| **WM_HOST_HOSTNAME_MANAGEMENT**     | When true, the framework will be able to set the hostname of the host                                        |
| **WM_HOST_WIFI_MANAGEMENT**         | (Requires wpa suplicant) When true, it will allow the framework to customize the WiFi client                 |
| **WM_HOST_USER_MANAGEMENT**         | When true, it will allow the framework to control the user's password                                        |
| **WM_HOST_TTY_MANAGEMENT**          | When true, the framework will allows the creation of TTY symlinks                                            |
| **WM_HOST_KEYBOARD_MANAGEMENT**     | When true, the framework will be able to tweak the host's keyboard                                           |
| **WM_HOST_SUPPORT_MANAGEMENT**      | (Requires systemd) When true, the framework will establish services to connect to a wirepas support endpoint |
| **WM_HOST_DBUS_MANAGEMENT**         | When true, the framework will copy the DBUS management files under the host environment                      |
| **WM_HOST_DOCKER_PRUNE_ALL**        | When true, the framework will prune any docker images that are not currently being used by any container     |

<!--- bound for deprecation

| **Variable**         | **Definition**                 |
| --- | --- |
| ##WM_DOCKER_REGISTRY | (##WM_DOCKER_REGISTRY_DEFAULT) |
| ### BITRATE_CONFIGURATION
| ##WM_GW_SINK_UART_BITRATE      | The baudrate to use when communicating with the sink device (##WM_GW_SINK_UART_BITRATE_DEFAULT)

 -->

[here_environment_feature]: ../environment/feature.env
