#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail
umask 002

# Base models - Checkpoints and VAE
function build_models_base() {
    # Skip prebuild if SKIP_PREBUILD is set to true
    if [[ "${SKIP_PREBUILD,,}" == "true" ]]; then
        printf "SKIP_PREBUILD is set to true, skipping base model downloads...\n"
        return 0
    fi

    CHECKPOINT_MODELS=(
        "https://huggingface.co/a34384300/XSarchitectural-InteriorDesign-ForXSLora/resolve/main/xsarchitectural_v11.ckpt"
        "https://civitai.com/api/download/models/501240" #realisticVisionV60B1_v51HyperVAE.safetensors
    )

    CHECKPOINT_MODELS_SDXL=(
        # "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
        # "https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors"
    )

    UPSCALE_MODELS=(
        "https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth"
    )
    

    VAE_MODELS=(
        # "https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
    )

    LORA_MODELS=(
        # "https://civitai.com/api/download/models/30384" #xsarchitectural-7.safetensors
    )

    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/ckpt" \
        "${CHECKPOINT_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/ckpt/SDXL" \
        "${CHECKPOINT_MODELS_SDXL[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/vae" \
        "${VAE_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/lora" \
        "${LORA_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/upscale_models" \
        "${UPSCALE_MODELS[@]}"        
}

# Include the download helper functions
source /opt/ai-dock/bin/build/layer99/download_helpers.sh

build_models_base
fix-permissions.sh -o container
