#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail
umask 002

# Segmentation models
function build_models_segmentation() {
    # Skip prebuild if SKIP_PREBUILD is set to true
    if [[ "${SKIP_PREBUILD,,}" == "true" ]]; then
        printf "SKIP_PREBUILD is set to true, skipping segmentation model downloads...\n"
        return 0
    fi

    SAMS_MODELS=(
        "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth"
    )

    SAM2_MODELS=(
        "https://dl.fbaipublicfiles.com/segment_anything_2/092824/sam2.1_hiera_large.pt"
    )

    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/sams" \
        "${SAMS_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/sam2" \
        "${SAM2_MODELS[@]}"
}

# Include the download helper functions
source /opt/ai-dock/bin/build/layer99/download_helpers.sh

build_models_segmentation
fix-permissions.sh -o container
