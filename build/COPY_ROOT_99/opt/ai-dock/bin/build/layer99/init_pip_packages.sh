#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail
umask 002

# Use this layer to add nodes and models

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)
# Packages are installed after nodes so we can fix them...
PIP_PACKAGES=(
    "comfyui-frontend-package==1.23.4"
    "comfyui-workflow-templates==0.1.41"
    "comfyui-embedded-docs==0.2.4"
    "torch"
    "torchsde"
    "torchvision"
    "torchaudio"
    "numpy>=2.0.0"
    "einops"
    "transformers>=4.37.2"
    "tokenizers>=0.13.3"
    "sentencepiece"
    "safetensors>=0.4.2"
    "aiohttp>=3.11.8"
    "yarl>=1.18.0"
    "pyyaml"
    "Pillow"
    "scipy"
    "tqdm"
    "psutil"
    "alembic"
    "SQLAlchemy"
    
    # Non essential dependencies
    "kornia>=0.7.1"
    "spandrel"
    "soundfile"
    "av>=14.2.0"
    "pydantic~=2.0"
    "pydantic-settings~=2.0"
    "diffusers"
    "opencv-python>=4.10.0"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function build_extra_start() {
    # Skip prebuild if SKIP_PREBUILD is set to true
    if [[ "${SKIP_PREBUILD,,}" == "true" ]]; then
        printf "SKIP_PREBUILD is set to true, skipping model downloads...\n"
        return 0
    fi
    build_extra_get_pip_packages
}

function build_extra_get_pip_packages() {
    if [ ${#PIP_PACKAGES[@]} -gt 0 ]; then
        "$COMFYUI_VENV_PIP" install --no-cache-dir \
            "${PIP_PACKAGES[@]}"
    fi
}

umask 002

build_extra_start
fix-permissions.sh -o container