ARG TENSORFLOW_IMAGE=nvcr.io/nvidia/tensorflow:25.02-tf2-py3
FROM ${TENSORFLOW_IMAGE}

# Install JupyterHub to match the hub version
RUN pip install --no-cache-dir \
    jupyterhub==5 \
    notebook

# Use existing ubuntu user (UID 1000) and rename it to jovyan for consistency
RUN usermod -l jovyan ubuntu && \
    groupmod -n jovyan ubuntu 2>/dev/null || true && \
    usermod -aG users,video jovyan && \
    usermod -d /home/jovyan -m jovyan && \
    mkdir -p /home/jovyan/work && \
    chown -R jovyan:jovyan /home/jovyan

USER jovyan
WORKDIR /home/jovyan/work

CMD ["jupyterhub-singleuser"]
