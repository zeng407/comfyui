#!/bin/bash

# Shared download helper functions for model downloads

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
