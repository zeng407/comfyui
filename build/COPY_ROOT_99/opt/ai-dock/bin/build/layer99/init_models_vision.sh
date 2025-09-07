#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail
umask 002

# Vision and detection models
function build_models_vision() {
    # Skip prebuild if SKIP_PREBUILD is set to true
    if [[ "${SKIP_PREBUILD,,}" == "true" ]]; then
        printf "SKIP_PREBUILD is set to true, skipping vision model downloads...\n"
        return 0
    fi

    CLIP_VERSION_MODELS=(
        "https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors|CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
    )

    IPADAPTER_MODELS=(
        "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors"
        "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sd15.safetensors"
        "https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl.safetensors"
    )

    GROUNDING_DINO_MODELS=(
        "https://huggingface.co/ShilongLiu/GroundingDINO/resolve/main/GroundingDINO_SwinT_OGC.cfg.py"
        "https://huggingface.co/ShilongLiu/GroundingDINO/resolve/main/groundingdino_swint_ogc.pth"
    )

    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/clip_vision" \
        "${CLIP_VERSION_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/ipadapter" \
        "${IPADAPTER_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/grounding-dino" \
        "${GROUNDING_DINO_MODELS[@]}"
}

# Include the download helper functions
source /opt/ai-dock/bin/build/layer99/download_helpers.sh

build_models_vision
fix-permissions.sh -o container
