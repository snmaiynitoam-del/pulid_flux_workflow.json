# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
# The workflow contains custom nodes from an unknown registry. None include an aux_id (GitHub repo) in the provided metadata,
# so they cannot be automatically installed or cloned. Please provide registry IDs or GitHub repos for these packages.
# Could not resolve custom node CheckpointLoaderSimple (unknown_registry, no aux_id provided) - skipped
# Could not resolve custom node PulidFluxModelLoader (unknown_registry, no aux_id provided) - skipped
# Could not resolve custom node PulidFluxInsightFaceLoader (unknown_registry, no aux_id provided) - skipped
# Could not resolve custom node PulidFluxEvaClipLoader (unknown_registry, no aux_id provided) - skipped
# Could not resolve custom node LoadImage (unknown_registry, no aux_id provided) - skipped
# Could not resolve custom node ApplyPulidFlux (unknown_registry, no aux_id provided) - skipped
# Could not resolve custom node CLIPTextEncode (unknown_registry, no aux_id provided) - skipped
# Could not resolve custom node CLIPTextEncode (unknown_registry, no aux_id provided) - skipped
# Could not resolve custom node EmptyLatentImage (unknown_registry, no aux_id provided) - skipped
# Could not resolve custom node KSampler (unknown_registry, no aux_id provided) - skipped
# Could not resolve custom node VAEDecode (unknown_registry, no aux_id provided) - skipped
# Could not resolve custom node SaveImage (unknown_registry, no aux_id provided) - skipped

# download models into comfyui
RUN comfy model download --url https://huggingface.co/Kijai/flux-fp8/resolve/main/flux1-dev-fp8.safetensors --relative-path models/diffusion_models --filename flux1-dev-fp8.safetensors
RUN comfy model download --url https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.1.safetensors --relative-path models/diffusion_models --filename pulid_flux_v0.9.1.safetensors
RUN comfy model download --url https://huggingface.co/QuanSun/EVA-CLIP/resolve/main/EVA02_CLIP_L_336_psz14_s6B.pt --relative-path models/clip --filename EVA02_CLIP_L_336_psz14_s6B.pt

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
