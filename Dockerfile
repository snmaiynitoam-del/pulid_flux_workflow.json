# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# Install PuLID custom node for Flux face conditioning
RUN comfy node install comfyui-pulid --mode remote

# Download Flux checkpoint to correct path
RUN comfy model download --url https://huggingface.co/Kijai/flux-fp8/resolve/main/flux1-dev-fp8.safetensors --relative-path models/checkpoints --filename flux1-dev-fp8.safetensors

# Download PuLID model to pulid folder
RUN comfy model download --url https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.1.safetensors --relative-path models/pulid --filename pulid_flux_v0.9.1.safetensors

# Download EVA-CLIP model
RUN comfy model download --url https://huggingface.co/QuanSun/EVA-CLIP/resolve/main/EVA02_CLIP_L_336_psz14_s6B.pt --relative-path models/clip --filename EVA02_CLIP_L_336_psz14_s6B.pt

# Download InsightFace antelopev2 models (using wget instead of curl)
RUN mkdir -p /comfyui/models/insightface/models/antelopev2 && \
    cd /comfyui/models/insightface/models/antelopev2 && \
    wget -O 1k3d68.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/1k3d68.onnx && \
    wget -O 2d106det.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/2d106det.onnx && \
    wget -O genderage.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/genderage.onnx && \
    wget -O glintr100.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/glintr100.onnx && \
    wget -O scrfd_10g_bnkps.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/scrfd_10g_bnkps.onnx
