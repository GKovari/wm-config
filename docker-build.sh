#!/usr/bin/env bash
#
# Wirepas
#
# Generic docker build tag and push utility
# Please make sure to define a source file with the default environment
# parameters (see container/build_defaults.sh)
#

trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR

set -o nounset
set -o errexit
set -o errtrace

_ME=$(basename "${0}")

_get_build_history()
{
    rm build-*.txt || true
    LAST_HASH=$(git log -n 1 --oneline --format=%H)
    date > build-${LAST_HASH}.txt
    git log -n "${DOCKER_BUILD_GIT_HISTORY_LENGTH}" --oneline >> build-${LAST_HASH}.txt
}


_read_pypkg_version()
{
    PYTHON_PKG_VERSION=""
    PYTHON_PKG_VERSION=$(cat setup.py|\
                  awk '/version=/{print $NF}'|\
                  awk '{split($0,a,"="); print a[2]}'|\
                   tr -d ','|\
                   sed "s/'//g") || true
    echo "python package version : ${PYTHON_PKG_VERSION}"
}

_defaults()
{
    PATH_PROJECT_DEFAULTS_PATH=${PATH_PROJECT_DEFAULTS_PATH:-"./build_defaults.env"}
    echo "Reading ${PATH_PROJECT_DEFAULTS_PATH}"
    source ${PATH_PROJECT_DEFAULTS_PATH}

    # default defaults if not defined in build file
    DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG:-"latest"}
    DOCKER_BUILD_CACHE=${DOCKER_BUILD_CACHE:-""}
    DOCKER_PLATFORM=${DOCKER_PLATFORM:-"x86"}

    DOCKER_BUILD_ARGS=${DOCKER_BUILD_ARGS:-""}
    DOCKER_BUILD_TARGET=${DOCKER_BUILD_TARGET:-""}

    DOCKER_FILE=${DOCKER_FILE:-"./Dockerfile"}
    DOCKER_REPO=${DOCKER_REPO:-""}
    DOCKER_PUSH=${DOCKER_PUSH:-"false"}
    DOCKER_SKIP_BUILD=${DOCKER_SKIP_BUILD:-"false"}

    DOCKER_IMAGE_ARM_NAME=${DOCKER_IMAGE_ARM_NAME:-""}
    DOCKER_ARM_BUILD_TARGET=${DOCKER_ARM_BUILD_TARGET:-""}

    DOCKER_IMAGE_TAG_PYTHON_VERSION=${DOCKER_IMAGE_TAG_PYTHON_VERSION:-"false"}
    DOCKER_BUILD_GIT_HISTORY_LENGTH=${DOCKER_BUILD_GIT_HISTORY_LENGTH:-"10"}

}



wmconfig_help() {
  cat <<HEREDOC
Docker build utility

Usage:
  ${_ME} [<arguments>]
  ${_ME} -h | --help

Options:
  -h --help           Show this screen.
  --image             Name to tag docker image with (${DOCKER_IMAGE_NAME})
  --tag               Tag to associate with docker image (${DOCKER_IMAGE_TAG})
  --no-cache          Disables build cache (${DOCKER_BUILD_CACHE})
  --arm               Builds for arm (rpi)
  --build-target      Dockerfile target to build (${DOCKER_BUILD_TARGET})
  --skip-build        Skips build (${DOCKER_SKIP_BUILD})
  --repo              Repository where to push image to (${DOCKER_REPO})
  --push              Pushes the tagged image to the target repository (${DOCKER_PUSH})
  --py-tag            Uses the python version as the image tag (${DOCKER_IMAGE_TAG_PYTHON_VERSION})
  --debug             Sets bash debug (-x)
  --build-defaults    Sets the path for the build defaults (${PATH_PROJECT_DEFAULTS_PATH})
HEREDOC
}


_parse_build_default_path()
{
    # Gather commands
    while [[ "${#}" -gt 0 ]]
    do
        key="${1}"
        echo "${key}"
        case "${key}" in
            --build-defaults |--build_defaults)
            PATH_PROJECT_DEFAULTS_PATH="${2}"
            shift
            shift
            ;;
             *)    # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
            ;;
        esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters
}


_parse()
{
    # Gather commands
    while [[ "${#}" -gt 0 ]]
    do
        key="${1}"
        echo "${key}"
        case "${key}" in
            --skip-build | --skip_build)
            DOCKER_SKIP_BUILD="true"
            shift
            ;;
            --image)
            DOCKER_IMAGE_NAME="${2}"
            shift
            shift
            ;;
            --tag)
            DOCKER_IMAGE_TAG="${2}"
            DOCKER_IMAGE_TAG_PYTHON_VERSION="false"
            shift
            shift
            ;;
            --no-cache)
            DOCKER_BUILD_CACHE="--no-cache"
            shift
            ;;
            --arm)
            DOCKER_PLATFORM="arm"
            DOCKER_BUILD_TARGET="--target ${DOCKER_ARM_BUILD_TARGET}"
            if [ ! -z ${DOCKER_IMAGE_ARM_NAME} ]
            then
                DOCKER_IMAGE_NAME=${DOCKER_IMAGE_ARM_NAME}
            fi
            shift
            ;;
            --arm-build-target)
            DOCKER_PLATFORM="arm"
            DOCKER_ARM_BUILD_TARGET="${2}"
            DOCKER_BUILD_TARGET="--target ${DOCKER_ARM_BUILD_TARGET}"
            shift
            ;;
            --repo | --repository )
            DOCKER_REPO="${2}"
            shift
            shift
            ;;
            --push)
            DOCKER_PUSH="true"
            shift
            ;;
            --py-tag | py_tag)
            DOCKER_IMAGE_TAG_PYTHON_VERSION="true"
            shift
            ;;
            --build-defaults |--build_defaults)
            PATH_PROJECT_DEFAULTS_PATH="${2}"
            shift
            shift
            ;;
            --debug)
            set -x
            shift
            ;;
            *)
            echo "Unknown argument : ${1}"
            wmconfig_help
            exit 1
        esac
    done
}

_build()
{
    if [[ "${DOCKER_SKIP_BUILD}" != "true" ]]
    then

        if [[ "${DOCKER_IMAGE_TAG_PYTHON_VERSION}" == "true" ]]
        then
            _read_pypkg_version
            DOCKER_IMAGE_TAG="${PYTHON_PKG_VERSION}"
        fi

        _get_build_history || true
        echo "building ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} [${DOCKER_BUILD_CACHE}]"
        docker build \
            --compress ${DOCKER_BUILD_CACHE} \
           -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG . \
           -f ${DOCKER_FILE} ${DOCKER_BUILD_TARGET} \
           ${DOCKER_BUILD_ARGS}
    fi
}

_repo()
{
    if [[ ! -z "${DOCKER_REPO}" ]]
    then
        echo "tagging ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} --> ${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
        docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
    fi
}

_push()
{
    if [[ "${DOCKER_PUSH}" == "true" ]] && [[ ! -z "${DOCKER_REPO}" ]]
    then
        echo "pushing ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} --> ${DOCKER_REPO}"
        docker push ${DOCKER_REPO}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
    fi
}

_main()
{
    _parse_build_default_path "${@}"
    _defaults
    _parse "${@}"
    _build
    _repo
    _push
}

_main "${@}"
