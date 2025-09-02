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

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/cubiq/ComfyUI_IPAdapter_plus"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/yolain/ComfyUI-Easy-Use"
    "https://github.com/chrisgoringe/cg-use-everywhere"
    "https://github.com/neverbiasu/ComfyUI-SAM2"
    "https://github.com/cubiq/ComfyUI_essentials"
)

CHECKPOINT_MODELS=(
    # "https://huggingface.co/a34384300/XSarchitectural-InteriorDesign-ForXSLora/resolve/main/xsarchitectural_v11.ckpt"
    # Using a publicly available SDXL model instead
    "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
)

UNET_MODELS=(

)

LORA_MODELS=(
    #"https://civitai.com/api/download/models/16576"
    "https://civitai.com/api/download/models/30384" #xsarchitectural-7.safetensors
)

VAE_MODELS=(
    #"https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors"
    #"https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"
    "https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
)

ESRGAN_MODELS=(
    #"https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth"
    #"https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"
    #"https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth"
)

CONTROLNET_MODELS=(
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_canny-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_depth-fp16.safetensors"
    #"https://huggingface.co/kohya-ss/ControlNet-diff-modules/resolve/main/diff_control_sd15_depth_fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_hed-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_mlsd-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_normal-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_openpose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_scribble-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_seg-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_canny-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_color-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_depth-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_keypose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_openpose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_seg-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_sketch-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_style-fp16.safetensors"
)

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

CLIP_VERSION_MODELS=(
    "https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors|CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors" # CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors
    # "https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/image_encoder/model.safetensors"
)

SAMS_MODELS=(
    "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth"
)

IPADAPTER_MODELS=(
    "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors"
    "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sd15.safetensors"
    "https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl.safetensors"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function build_extra_start() {
    build_extra_get_apt_packages
    build_extra_get_nodes
    build_extra_get_pip_packages
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/ckpt" \
        "${CHECKPOINT_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/unet" \
        "${UNET_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/lora" \
        "${LORA_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/vae" \
        "${VAE_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/controlnet/1.5" \
        "${CONTROLNET_MODELS_15[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/controlnet/SDXL/controlnet-canny-sdxl-1.0" \
        "${CONTROLNET_MODELS_SDXL_CANNY[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/controlnet/SDXL/controlnet-depth-sdxl-1.0" \
        "${CONTROLNET_MODELS_SDXL_DEPTH[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/clip_vision" \
        "${CLIP_VERSION_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/sams" \
        "${SAMS_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/ipadapter" \
        "${IPADAPTER_MODELS[@]}"

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
function build_extra_get_pip_packages() {
    if [ ${#PIP_PACKAGES[@]} -gt 0 ]; then
        "$COMFYUI_VENV_PIP" install --no-cache-dir \
            "${PIP_PACKAGES[@]}"
    fi
}

function build_extra_get_models() {
    if [[ $# -lt 2 ]]; then
        return 0
    fi
    
    local dir="$1"
    shift
    local arr=("$@")
    
    # Skip if no models to download
    if [[ ${#arr[@]} -eq 0 ]]; then
        return 0
    fi
    
    mkdir -p "$dir"
    
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url_entry in "${arr[@]}"; do
        # Skip empty entries
        if [[ -z "$url_entry" ]]; then
            continue
        fi
        
        # Check if entry contains pipe separator for custom filename
        if [[ "$url_entry" == *"|"* ]]; then
            url="${url_entry%%|*}"      # Extract URL (everything before |)
            filename="${url_entry##*|}" # Extract filename (everything after |)
            printf "Downloading: %s as %s\n" "$url" "$filename"
            build_extra_download_with_filename "$url" "$dir" "$filename"
        else
            url="$url_entry"
            printf "Downloading: %s\n" "$url"
            build_extra_download_with_filename "$url" "$dir" ""
        fi
        printf "\n"
    done
}

# Download from $1 URL to $2 directory with $3 custom filename
function build_extra_download_with_filename() {
    local url="$1"
    local dir="$2"
    local custom_filename="$3"
    
    # Validate inputs
    if [[ -z "$url" || -z "$dir" ]]; then
        printf "Error: Invalid URL or directory\n"
        return 1
    fi
    
    # For Civitai URLs, handle redirect and get filename from final URL
    if [[ "$url" == *"civitai.com"* ]]; then
        printf "Getting filename from Civitai redirect...\n"
        
        # Follow redirect and get the final URL
        local final_url=$(curl -sL -o /dev/null -w '%{url_effective}' "$url" 2>/dev/null)
        
        # Extract filename from response-content-disposition parameter in the final URL
        local filename=$(echo "$final_url" | sed -n 's/.*filename%3D%22\([^%]*\)%22.*/\1/p')
        
        # If we couldn't extract filename, try alternative method
        if [[ -z "$filename" ]]; then
            # Try to get it from the redirect location header
            local redirect_url=$(curl -sI "$url" 2>/dev/null | grep -i "location:" | cut -d' ' -f2 | tr -d '\r')
            filename=$(echo "$redirect_url" | sed -n 's/.*filename%3D%22\([^%]*\)%22.*/\1/p')
        fi
        
        # If still no filename, use default
        if [[ -z "$filename" ]]; then
            filename="$(basename "$url").safetensors"
        fi
        if [[ -n "$custom_filename" ]]; then
            filename="$custom_filename"
        fi
        printf "Downloading as: %s\n" "$filename"
        wget -O "${dir}/${filename}" "$url" || {
            printf "Error: Failed to download from Civitai: %s\n" "$url"
            return 1
        }
    else
        # For Hugging Face and other URLs
        local wget_args=()
        
        # Add HF token if available
        if [[ -n "$HF_TOKEN" ]]; then
            wget_args+=("--header=Authorization: Bearer $HF_TOKEN")
        fi
        
        # Common wget arguments
        wget_args+=("-qnc" "--content-disposition" "--show-progress" "-e" "dotbytes=${4:-4M}")
        
        if [[ -n "$custom_filename" ]]; then
            printf "Downloading with custom filename: %s\n" "$custom_filename"
            wget "${wget_args[@]}" -O "${dir}/${custom_filename}" "$url" || {
                printf "Warning: Failed to download %s with auth, trying without auth...\n" "$url"
                # Try without auth token as fallback
                wget -qnc --content-disposition --show-progress -e dotbytes="${4:-4M}" -O "${dir}/${custom_filename}" "$url" || {
                    printf "Error: Failed to download %s\n" "$url"
                    return 1
                }
            }
        else
            printf "Downloading to directory: %s\n" "$dir"
            wget "${wget_args[@]}" -P "$dir" "$url" || {
                printf "Warning: Failed to download %s with auth, trying without auth...\n" "$url"
                # Try without auth token as fallback
                wget -qnc --content-disposition --show-progress -e dotbytes="${4:-4M}" -P "$dir" "$url" || {
                    printf "Error: Failed to download %s\n" "$url"
                    return 1
                }
            }
        fi
    fi
}

umask 002

build_extra_start
fix-permissions.sh -o container