#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail
umask 002

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function build_extra_start() {
    # Skip prebuild if SKIP_PREBUILD is set to true
    # if [[ "${SKIP_PREBUILD,,}" == "true" ]]; then
    #     printf "SKIP_PREBUILD is set to true, skipping ComfyUI test...\n"
    #     return 0
    # fi
    
    # Test ComfyUI installation
    cd /opt/ComfyUI
    source "$COMFYUI_VENV/bin/activate"
    LD_PRELOAD=libtcmalloc.so python main.py \
        --cpu \
        --listen 127.0.0.1 \
        --port 11404 \
        --disable-auto-launch \
        --quick-test-for-ci
    deactivate
}

umask 002

build_extra_start
fix-permissions.sh -o container