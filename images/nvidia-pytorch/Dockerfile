ARG PYTORCH_IMAGE=nvcr.io/nvidia/pytorch:26.01-py3
FROM ${PYTORCH_IMAGE}

# Install JupyterHub to match the hub version
RUN pip install --no-cache-dir \
    jupyterhub==5 \
    notebook

# Create jovyan user with UID 1001 (UID 1000 already exists in NVIDIA images)
# Add to video group (GID 44) for GPU access
RUN groupadd -g 100 users 2>/dev/null || true && \
    useradd -m -s /bin/bash -u 1001 -g 100 -G video jovyan && \
    mkdir -p /home/jovyan/work && \
    chown -R jovyan:users /home/jovyan

USER jovyan
WORKDIR /home/jovyan/work

CMD ["jupyterhub-singleuser"]
