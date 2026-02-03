# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# Download PuLID-Flux from HuggingFace (our own repo - guaranteed to work)
RUN cd /comfyui/custom_nodes && \
    mkdir -p ComfyUI-PuLID-Flux && \
    cd ComfyUI-PuLID-Flux && \
    wget -O pulid.zip "https://huggingface.co/snailmana99/comfyui-pulid-flux/resolve/main/ComfyUI-PuLID-Flux.zip" && \
    python -c "import zipfile; zipfile.ZipFile('pulid.zip').extractall('.')" && \
    rm pulid.zip && \
    pip install -r requirements.txt

# Download Flux checkpoint to correct path
RUN comfy model download --url https://huggingface.co/Kijai/flux-fp8/resolve/main/flux1-dev-fp8.safetensors --relative-path models/checkpoints --filename flux1-dev-fp8.safetensors

# Download PuLID model to pulid folder
RUN comfy model download --url https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.1.safetensors --relative-path models/pulid --filename pulid_flux_v0.9.1.safetensors

# Download EVA-CLIP model
RUN comfy model download --url https://huggingface.co/QuanSun/EVA-CLIP/resolve/main/EVA02_CLIP_L_336_psz14_s6B.pt --relative-path models/clip --filename EVA02_CLIP_L_336_psz14_s6B.pt

# Download InsightFace antelopev2 models
RUN mkdir -p /comfyui/models/insightface/models/antelopev2 && \
    cd /comfyui/models/insightface/models/antelopev2 && \
    wget -O 1k3d68.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/1k3d68.onnx && \
    wget -O 2d106det.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/2d106det.onnx && \
    wget -O genderage.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/genderage.onnx && \
    wget -O glintr100.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/glintr100.onnx && \
    wget -O scrfd_10g_bnkps.onnx https://huggingface.co/MonsterMMORPG/tools/resolve/main/scrfd_10g_bnkps.onnx
