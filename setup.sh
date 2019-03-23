#!/usr/bin/env bash
# Wirepas Oy

set -e

RUN_AFTER=${1:-"true"}

function _defaults
{
    HOST_ARCHITECTURE=$(uname -m)

    BUILD_VERSION="1.1.0"

    ARCHIVE_NAME="wmconfig.tar.gz"
    WM_SERVICE_HOME=${HOME}/wirepas/wm-config
    WM_SERVICE_ENTRYPOINT=${WM_SERVICE_ENTRYPOINT:-"/boot/wirepas"}
    WM_CFG_EXEC_NAME="wm-config"

    if [[ "${HOST_ARCHITECTURE}" == "armv7l" ]]
    then
        INSTALL_SYSTEM_WIDE=true
        WM_CFG_INSTALL_PATH=/usr/local/bin/
    else
        INSTALL_SYSTEM_WIDE=false
        WM_CFG_INSTALL_PATH=${HOME}/.local/bin
        export PATH=${PATH}:${HOME}/.local/bin/
    fi
}

##
## @brief      Removes any existing software and ensures entrypoint creation
##
##             This function removes existing source files and ensures the
##             rpi entrypoint exists.
##
function _clean_path
{
    if [[ "${HOST_ARCHITECTURE}" == "armv7l" ]]
    then
       sudo mkdir -p ${WM_SERVICE_ENTRYPOINT}
    fi
    rm -rf ${WM_SERVICE_HOME}
    mkdir -p ${WM_SERVICE_HOME}
}


##
## @brief      Checks if there is a tar bundle and extracts its contents
##
##             This function creates the service's home folder which
##             is controlled by the value in WM_SERVICE_HOME
##
function _check_for_tar
{
    if [[ -f "${HOME}/${ARCHIVE_NAME}" ]]
    then
        _clean_path
        mv ${HOME}/${ARCHIVE_NAME} ${WM_SERVICE_HOME}
        cd ${WM_SERVICE_HOME}
        tar -xvzf ${WM_SERVICE_HOME}/${ARCHIVE_NAME}
    fi
}


##
## @brief      copies the wmconfig executable to the system level executable
##
##             The fucntion attempts to source the path based on the tar
##             presence. If it is not present then it assumes it is
##             available in the bin folder where the executable has
##             been placed.
##
function _copy_wmconfig
{
    if [[ -f ${WM_SERVICE_HOME}/bin/wm-config.sh  ]]
    then
        echo "copying exec from bundle"
        _copy_target=${WM_SERVICE_HOME}/bin/wm-config.sh
        _is_clone=false
    elif [[ -f $(pwd)/bin/wm-config.sh  ]]
    then
        echo "assuming git clone: setting up ${WM_SERVICE_HOME}"

        export BUILD_VERSION=$(git log -n 1 --oneline --format=%h)

        _copy_target=$(pwd)/bin/wm-config.sh

         _TARGETS=("./bin/wm-config.sh" "./bin/wmconfig-settings-updater.sh")
        _set_build_number "${_TARGETS[@]}"

        echo "setting up ${WM_SERVICE_HOME}"
        rsync -a  . ${WM_SERVICE_HOME} --exclude .git

        _is_clone=true
    fi

    # copy and set permissions
    if [[ ${INSTALL_SYSTEM_WIDE} == true ]]
    then
        echo "installing wm-config system wide"
        sudo cp  --no-preserve=mode,ownership ${_copy_target} ${WM_CFG_INSTALL_PATH}/${WM_CFG_EXEC_NAME}
        sudo chmod +x ${WM_CFG_INSTALL_PATH}/${WM_CFG_EXEC_NAME}
    else
        echo "installing wm-config for current user"
        mkdir -p /home/${USER}/.local/bin || true
        cp  --no-preserve=mode,ownership ${_copy_target} ${WM_CFG_INSTALL_PATH}/${WM_CFG_EXEC_NAME}
        sudo chmod +x ${WM_CFG_INSTALL_PATH}/${WM_CFG_EXEC_NAME}
        export PATH=$PATH:/home/${USER}/.local/bin
    fi


    if [[ ${_is_clone} == "true" ]]
    then
        _restore_build_number "${_TARGETS[@]}"
    fi

}


function _set_build_number
{
    _targets=("$@")

    # sets the hash if possible
    for _target in "${_targets[@]}";
    do
        echo "filling version on: ${_target}"
        _temporary=${_target}.tmp

        cp ${_target} ${_temporary}
        sed -i "s/#FILLVERSION/$(date -u) - ${BUILD_VERSION}/g" ${_target}
    done
}

function _restore_build_number
{
    _targets=("$@")
    for target in "${_targets[@]}"
    do
        echo "reseting: ${target}"
        git checkout -- ${target}
    done
}

##
## @brief      Copies a custom environment into the entrypoint folder
##
##             This function looks up for any custom file in the home
##             folder and copies it over to the defined entrypoint.
##
function _copy_custom_env
{
    if [[ "${HOST_ARCHITECTURE}" == "armv7l" ]]
    then
        set +e
        for _cfile in ${HOME}/*custom*
        do
            echo "copying custom file ${HOME}/*custom*"
            sudo cp --no-preserve=mode,ownership ${_cfile} \
                ${WM_SERVICE_ENTRYPOINT}/custom.env
        done
        set -e
    fi
}

##
## @brief      The main function
##
function _main
{
    _defaults
    _check_for_tar
    _copy_custom_env
    _copy_wmconfig

    if [[ "${RUN_AFTER}" == "true" ]]
    then
        # execute
        wm-config "${@:2}"
    fi
}


_main "${@}"
