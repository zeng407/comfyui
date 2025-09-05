#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail
umask 002

# Use this layer to add nodes and models

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/cubiq/ComfyUI_IPAdapter_plus"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/yolain/ComfyUI-Easy-Use"
    "https://github.com/chrisgoringe/cg-use-everywhere"
    "https://github.com/neverbiasu/ComfyUI-SAM2"
    "https://github.com/cubiq/ComfyUI_essentials"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function build_extra_start() {
    # Skip prebuild if SKIP_PREBUILD is set to true
    if [[ "${SKIP_PREBUILD,,}" == "true" ]]; then
        printf "SKIP_PREBUILD is set to true, skipping model downloads...\n"
        return 0
    fi
    build_extra_get_apt_packages
    build_extra_get_nodes
    
}

function build_extra_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="/opt/ComfyUI/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                    "$COMFYUI_VENV_PIP" install --no-cache-dir \
                        -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                "$COMFYUI_VENV_PIP" install --no-cache-dir \
                    -r "${requirements}"
            fi
        fi
    done
}

function build_extra_get_apt_packages() {
    if [ ${#APT_PACKAGES[@]} -gt 0 ]; then
        $APT_INSTALL ${APT_PACKAGES[*]}
    fi
}

umask 002

build_extra_start
fix-permissions.sh -o container