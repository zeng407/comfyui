#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail
umask 002

# ControlNet models
function build_models_controlnet() {
    # Skip prebuild if SKIP_PREBUILD is set to true
    if [[ "${SKIP_PREBUILD,,}" == "true" ]]; then
        printf "SKIP_PREBUILD is set to true, skipping ControlNet model downloads...\n"
        return 0
    fi

    CONTROLNET_MODELS_15=(
        "https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_canny_fp16.safetensors"
        "https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors"   
    )

    CONTROLNET_MODELS_SDXL_CANNY=(
        "https://huggingface.co/xinsir/controlnet-canny-sdxl-1.0/resolve/main/diffusion_pytorch_model_V2.safetensors"
    )

    CONTROLNET_MODELS_SDXL_DEPTH=(
        "https://huggingface.co/xinsir/controlnet-depth-sdxl-1.0/resolve/main/diffusion_pytorch_model.safetensors"
    )

    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/controlnet/1.5" \
        "${CONTROLNET_MODELS_15[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/controlnet/SDXL/controlnet-canny-sdxl-1.0" \
        "${CONTROLNET_MODELS_SDXL_CANNY[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/controlnet/SDXL/controlnet-depth-sdxl-1.0" \
        "${CONTROLNET_MODELS_SDXL_DEPTH[@]}"
}

# Include the download helper functions
source /opt/ai-dock/bin/build/layer99/download_helpers.sh

build_models_controlnet
fix-permissions.sh -o container
