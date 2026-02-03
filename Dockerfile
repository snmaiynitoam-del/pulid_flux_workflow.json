# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# Clone PuLID-Flux from official GitHub repo (includes eva_clip folder)
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/balazik/ComfyUI-PuLID-Flux.git && \
    cd ComfyUI-PuLID-Flux && \
    pip install -r requirements.txt && \
    echo "=== PuLID files installed ===" && \
    ls -la && \
    echo "=== Checking eva_clip folder ===" && \
    ls -la eva_clip/

# Verify the custom node structure
RUN echo "=== Verifying custom node structure ===" && \
    ls -la /comfyui/custom_nodes/ && \
    ls -la /comfyui/custom_nodes/ComfyUI-PuLID-Flux/ && \
    cat /comfyui/custom_nodes/ComfyUI-PuLID-Flux/__init__.py

# Download Flux checkpoint to correct path
RUN comfy model download --url https://huggingface.co/Kijai/flux-fp8/resolve/main/flux1-dev-fp8.safetensors --relative-path models/checkpoints --filename flux1-dev-fp8.safetensors

# Download PuLID model to pulid folder
RUN comfy model download --url https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.1.safetensors --relative-path models/pulid --filename pulid_flux_v0.9.1.safetensors

# Download EVA-CLIP model (for PuLID face analysis)
RUN comfy model download --url https://huggingface.co/QuanSun/EVA-CLIP/resolve/main/EVA02_CLIP_L_336_psz14_s6B.pt --relative-path models/clip --filename EVA02_CLIP_L_336_psz14_s6B.pt

# Download Flux text encoders (required for text-to-image)
RUN comfy model download --url https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors --relative-path models/clip --filename t5xxl_fp8_e4m3fn.safetensors

RUN comfy model download --url https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors --relative-path models/clip --filename clip_l.safetensors

# Download InsightFace antelopev2 models
RUN mkdir -p /comfyui/models/insightface/models/antelopev2 && \
    cd /comfyui/models/insightface/models/antelopev2 && \
    wget -O 1k3d68.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/1k3d68.onnx && \
    wget -O 2d106det.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/2d106det.onnx && \
    wget -O genderage.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/genderage.onnx && \
    wget -O glintr100.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/glintr100.onnx && \
    wget -O scrfd_10g_bnkps.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/scrfd_10g_bnkps.onnx

# Final verification
RUN echo "=== Final custom_nodes listing ===" && \
    ls -la /comfyui/custom_nodes/
