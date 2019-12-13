<!-- auto_start -->

# List of settings

The following tables contain the full set of environmental
keys used by wm-config:

<!-- MarkdownTOC -->

-   [Host and dependency management](#host-and-dependency-management)
-   [Gateway and data broker settings](#gateway-and-data-broker-settings)
-   [Framework feature selection](#framework-feature-selection)

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

| _WM-CONFIG discovered variables_          | _Description_                                                                                                                                                                                           |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **WM_CFG_HOST_ARCH**                      | Host architecture                                                                                                                                                                                       |
| **WM_CFG_HOST_MODEL**                     | Host model                                                                                                                                                                                              |
| **WM_CFG_HOST_IS_RPI**                    | True when running on a RPi                                                                                                                                                                              |
| ---                                       | ---                                                                                                                                                                                                     |
| _WM-CONFIG static variables_              |                                                                                                                                                                                                         |
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
| _WM-CONFIG runtime configuration_         |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| **WM_HOST_INSTALL_DEPENDENCIES**          | When _true_ the wm-config will run (if present) ${WM_CFG_HOST_DEPENDENCIES_PATH}/host_requiremens.sh and ${WM_CFG_HOST_DEPENDENCIES_PATH}/requirements.txt (##WM_CFG_HOST_INSTALL_DEPENDENCIES_DEFAULT) |
| **WM_HOST_UPGRADE_PACKAGES**              | When _true_ the wm-config will ensure all host packages are upgraded (##WM_CFG_HOST_UPGRADE_DEFAULT)                                                                                                    |
| **WM_CFG_STARTUP_DELAY**                  | Sets the amount of seconds to delay the execution of wm-config (_default=0_)                                                                                                                            |
| **WM_CFG_REBOOT_DELAY**                   | Sets the amount of seconds to wait before taking an action, such as a status report (_default=2_)                                                                                                       |
| **WM_CFG_PYTHON_VERSION**                 | Python version to use when creating the virtual environment (_default=python3_)                                                                                                                         |
| **WM_CFG_PYTHON_VIRTUAL_ENV**             | Path where to create or find the python virtual environment where to install the wm-config dependencies (_default=${HOME}/.local/wirepas/virtualenv/wm-config_)                                         |
| **WM_CFG_WEBHOOK_POST_URL**               | A webhook where to post information about the wm-config execution (_default=unset_)                                                                                                                     |
| ---                                       | ---                                                                                                                                                                                                     |
| _WM-CONFIG updater_                       | ---                                                                                                                                                                                                     |
| ---                                       | ---                                                                                                                                                                                                     |
| **WM_CFG_FRAMEWORK_UPDATE**               | When _true_ the wm-config will pull an update image for the framework files (_default=false_)                                                                                                           |
| **WM_CFG_UPDATER_VERSION**                | The wm-config release version to pull - image's tag  (_default=latest_)                                                                                                                                 |
| **WM_CFG_UPDATER_IMAGE**                  | The registry and name of the docker image containing the wm-config files (_default=wirepas/wm-config_)                                                                                                  |
| ---                                       | ---                                                                                                                                                                                                     |
| _Docker daemon configuration_             |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| **WM_DOCKER_STATUS_DELAY**                | The amount of seconds to wait before displaying the gateway service status (_default=2_)                                                                                                                |
| **WM_DOCKER_USERNAME**                    | The user name to use when logging in with Docker (_default=unset_)                                                                                                                                      |
| **WM_DOCKER_PASSWORD**                    | The user's password to use when logging in with docker (_default=unset_)                                                                                                                                |
| **WM_DOCKER_DAEMON_JSON**                 | **Advanced** The JSON text to configure the docker daemon with (_default=unset_)                                                                                                                        |
| **WM_DOCKER_CLEANUP**                     | Forces a cleanup of all running docker containers and performs a system prune  (_default=true_)                                                                                                         |
| **WM_DOCKER_FORCE_RECREATE**              | Ensures that containers are recreated whenever the services state is monitored (_default=false_)                                                                                                        |
| ---                                       | ---                                                                                                                                                                                                     |
| _Filesystem and access control_           |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| **WM_HOST_FILESYSTEM_MANAGEMENT**         | When true expands the filesystem  (default: false (x86), true (raspi))                                                                                                                                  |
| **WM_HOST_HOSTNAME**                      | Sets the hostname of the host (##WM_HOST_SET_HOSTNAME_DEFAULT)                                                                                                                                          |
| **WM_HOST_USER_NAME**                     | The username of the host's admin user (_default=${USER}_)                                                                                                                                               |
| **WM_HOST_USER_PASSWORD**                 | The password of the host's admin user (_default=unset_)                                                                                                                                                 |
| **WM_HOST_USER_PPKI**                     | The public key to authorize in the ssh authorized keys (_default=unset_)                                                                                                                                |
| **WM_HOST_SSH_ENABLE_PASSWORD_LOGIN**     | Enables ssh login using plain text passwords (_default=true_)                                                                                                                                           |
| ---                                       | ---                                                                                                                                                                                                     |
| _Periodic job control (requires systemd)_ |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| **WM_SYSTEMD_UPDATER**                    | The name of the systemd job that monitors the wm-config state (_default=wirepas-updater_)                                                                                                               |
| **WM_SYSTEMD_UPDATER_INTERVAL**           | (_default=2592000_)                                                                                                                                                                                     |
| **WM_SYSTEMD_UPDATER_ENABLE**             | When _true_ the systemd job will be enabled and started (_default=true_)                                                                                                                                |
| **WM_SYSTEMD_UPDATER_DISABLE**            | When _true_ the systemd job will be disabled (_default=false_)                                                                                                                                          |
| ---                                       | ---                                                                                                                                                                                                     |
| _Internet connectivity_                   |                                                                                                                                                                                                         |
| ---                                       | ----                                                                                                                                                                                                    |
| **WM_HOST_BLACKLIST_IPV6**                | Blacklists the IPv6 module and reboots the host (default=false (x86), true (raspi))                                                                                                                     |
| **WM_WIFI_ENABLE**                        | When true forces the WiFi interface to be down  (##WM_WIFI_DISABLE_DEFAULT)                                                                                                                             |
| **WM_WIFI_AP_SSID**                       | The WiFi SSID where the host should connect to (_default=unset_)                                                                                                                                        |
| **WM_WIFI_AP_PASSWORD**                   | The WiFi's SSID password (_default=unset_)                                                                                                                                                              |
| ---                                       | ---                                                                                                                                                                                                     |
| _For Wirepas support_                     |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| **WM_SUPPORT_PORT**                       | For Wirepas support (_default=unset_)                                                                                                                                                                   |
| **WM_SUPPORT_HOSTNAME**                   | For Wirepas support (_default=host.extwirepas.com_)                                                                                                                                                     |
| **WM_SUPPORT_KEY**                        | For Wirepas support (_default=/support.pem_)                                                                                                                                                            |
| **WM_SUPPORT_USERNAME**                   | For Wirepas support (_default=${USER}_)                                                                                                                                                                 |
| **WM_SUPPORT_KEY_PATH**                   | For Wirepas support (_default=${HOME}/.ssh/support.pem_)                                                                                                                                                |
| ---                                       | ---                                                                                                                                                                                                     |
| _Keyboard settings_                       |                                                                                                                                                                                                         |
| ---                                       | ---                                                                                                                                                                                                     |
| **WM_HOST_KEYBOARD_CONFIGURE**            | Sets the host's keyboard (##WM_HOST_SET_KEYBOARD_DEFAULT)                                                                                                                                               |
| **WM_HOST_KEYBOARD_XKBMODEL**             | Defines the host's keyboard model (_default=pc105_)                                                                                                                                                     |
| **WM_HOST_KEYBOARD_BACKSPACE**            | Defines the host's keyboard backspace (_default=guess_)                                                                                                                                                 |
| **WM_HOST_KEYBOARD_XKBOPTIONS**           | Defines the host's keyboard options (_default=unset_)                                                                                                                                                   |
| **WM_HOST_KEYBOARD_XKBLAYOUT**            | Defines the host's keyboard layout (_default=gb_)                                                                                                                                                       |
| **WM_HOST_KEYBOARD_XKBVARIANT**           | Defines the host's keyboard variant (_default=unset_)                                                                                                                                                   |
| **WM_HOST_AVAHI_DAEMON_MANAGEMENT**       | Where to source avahi services from (default=false (x86), true (raspi))                                                                                                                                 |

## Gateway and data broker settings

| _MQTT broker settings_                         |                                                                                                                                        |
| ---------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| **WM_SERVICES_MQTT_HOSTNAME**                  | A host where to push the gateway data, eg, MQTT broker hostname or ip  (_default=host.extwirepas.com_)                                 |
| **WM_SERVICES_MQTT_USERNAME**                  | The MQTT username (_default=mqttuser_)                                                                                                 |
| **WM_SERVICES_MQTT_PASSWORD**                  | The MQTT's username password corresponding (_default=uiaidujfk1897fyeu023849sdh?(_)                                                    |
| **WM_SERVICES_MQTT_PORT**                      | Defines the MQTT port to use (unsecure 1883, secure 8883) (_default=8883_)                                                             |
| **WM_SERVICES_MQTT_ALLOW_UNSECURE**            | Must be set to true to allow unsecure connections, eg, to port 1883 (_default=unset_)                                                  |
| **WM_SERVICES_MQTT_CERTIFICATE_CHAIN**         | The container path where to find the root ca certificates (_default=unset_)                                                            |
| ---                                            | ---                                                                                                                                    |
| _Gateway metadata, transport and sink service_ |                                                                                                                                        |
| ---                                            | ---                                                                                                                                    |
| **WM_GW_STATE**                                | The state of the gateway services to enforce (start/stop) (_default=start_)                                                            |
| **WM_GW_ID**                                   | The id used to identifying the gateway at the MQTT level (_default=`hostname`_)                                                        |
| **WM_GW_MODEL**                                | Metadata about the gateway model (_default=wirepas-evk_)                                                                               |
| **WM_GW_VERSION**                              | Metadata about the gateway version (_default=latest_)                                                                                  |
| **WM_GW_WHITENED_ENDPOINTS_FILTER**            | List of endpoints whose payload should be zeroed out when published to the broker  (_default=unset_)                                   |
| **WM_GW_IGNORED_ENDPOINTS_FILTER**             | List of endpoints that should not be published to the MQTT broker (_default=unset_)                                                    |
| **WM_GW_IMAGE**                                | The name of the WM Gateway Docker image to pull  (_default=wirepas/gateway_)                                                           |
| **WM_GW_VERSION**                              | The build or docker tag to use (_default=latest_)                                                                                      |
| **WM_GW_SINK_UART_PORT**                       | The port where a Wirepas sink can be found from (_default=/dev/ttyWM_)                                                                 |
| **WM_GW_SINK_ID**                              | The pseudo id of the sink served by the sink service (_default=0_)                                                                     |
| **WM_GW_SERVICES_USER_PATH**                   | **Advanced** The path to create and overlay within the containers (_default=/user_)                                                    |
| **WM_GW_SERVICES_ENV_FILE**                    | **Advanced** Location of the environment file used by the transport and sink service (_default=/services.env_)                         |
| **WM_GW_TRANSPORT_SERVICE_CMD**                | **Advanced** The command to use with the transport service container (_default=transport_)                                             |
| **WM_GW_TRANSPORT_SERVICE_NETWORK**            | **Advanced** The network where to attach the transport service container (_default=network_mode:_)                                     |
| **WM_GW_SINK_SERVICE_CMD**                     | **Advanced** The command to use with the sink service container (_default=sink_)                                                       |
| **WM_GW_SINK_PORT_RULE**                       | **Advanced** The sink ports to use during the auto enumerate (\*default=/dev/ttyACM\*\*)                                               |
| **WM_GW_SINK_BLACKLIST**                       | **Advanced** A patter or device to ignore during the auto enumeration (_default=unset_)                                                |
| **WM_GW_SINK_BITRATE_CONFIGURATION**           | **Advanced** An array with the bitrate to use for a given sink. The sink id will match the array index (_default=unset_)               |
| **WM_GW_SINK_ENUMERATION**                     | **Advanced** Set to true to enable the automatic enumeration of tty ports - removes the need to specify a given port (_default=false_) |
| **WM_GW_DBUS_CONF**                            | **Advanced** The DBUS configuration file to be present in the host environment (_default=com.wirepas.sink.conf_)                       |
| **WM_GW_DBUS_CONF_USER**                       | **Advanced** The user that should be set within the DBUS configuration (_default=root_)                                                |
| **WM_HOST_TTY_SYMLINK**                        | The serial alias to associate with a Wirepas complaint device attached to the host (_default=ttyWM_)                                   |

## Framework feature selection

The feature keys enable or disable certain functionality of the framework, _regardless_ of the other keys' values.

| _WM-CONFIG feature_                 | _Description_                                                                                                |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------ |
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

[here_environment_feature]: ../environment/feature.env

<!-- auto_end -->
