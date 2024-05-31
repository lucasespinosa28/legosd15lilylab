FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-runtime AS builder
RUN mkdir /app
WORKDIR /app

RUN export NVIDIA_DISABLE_REQUIRE=true
# TODO: Cleanup and re-eval how many of these dependencies are actually necessary
# Install dependencies

RUN apt-get update && apt-get install -y git curl jq && apt-get clean
# Download ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI/

RUN git clone https://github.com/trojblue/trNodes app/ComfyUI/custom_nodes/trNodes

RUN  export DEBIAN_FRONTEND=noninteractive 
RUN  pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 
RUN  pip3 install -r /app/ComfyUI/requirements.txt
RUN  pip install -U "huggingface_hub[cli]"
RUN  huggingface-cli download runwayml/stable-diffusion-v1-5 v1-5-pruned-emaonly.ckpt --local-dir /app/ComfyUI/models/checkpoints/
# ADD Duskfall_BadHands_Neg.pt /app/ComfyUI/models/embeddings/Duskfall_BadHands_Neg.pt
RUN huggingface-cli download --repo-type dataset  gsdf/EasyNegative EasyNegative.pt --local-dir /app/ComfyUI/embeddings/

RUN cd /app/ComfyUI/models/loras/ && curl -o lego_v2.0.768.safetensors  https://civitai.com/api/download/models/150123


FROM builder as runner
ADD entrypoint.py /app/entrypoint.py

# Add our workflows
ADD workflow.json /app/workflow.json

# Set the name of our chosen model
RUN jq '.["4"].inputs.ckpt_name = "v1-5-pruned-emaonly.ckpt"' /app/workflow.json > /app/temp_workflow.json && mv /app/temp_workflow.json /app/workflow.json

ENTRYPOINT ["python3", "-u", "/app/entrypoint.py"]