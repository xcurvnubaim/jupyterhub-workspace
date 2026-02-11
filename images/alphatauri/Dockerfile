FROM nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libgles2 \
    libxml2 \
    libopenmpi-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Rename ubuntu user to jovyan and give ownership of /opt
RUN usermod -l jovyan ubuntu && \
    groupmod -n jovyan ubuntu 2>/dev/null || true && \
    usermod -aG users,video jovyan && \
    usermod -d /home/jovyan -m jovyan && \
    mkdir -p /home/jovyan/work && \
    chown -R jovyan:jovyan /home/jovyan /opt

USER jovyan
WORKDIR /home/jovyan

# Install Miniforge as jovyan (will create /opt/conda owned by jovyan)
RUN wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 5 \
    https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh \
    -O /tmp/miniforge.sh \
    && bash /tmp/miniforge.sh -b -p /opt/conda \
    && rm /tmp/miniforge.sh

ENV PATH=/opt/conda/bin:$PATH

# Install the Scientific Stack
RUN mamba install -y -c conda-forge \
    python=3.11 \
    jupyterhub=5.2.1 \
    jupyterlab=4.3.4 \
    jupyter-lsp \
    python-lsp-server \
    "numpy>=2.1" \
    "pandas>=2.2.2" \
    "scipy>=1.14" \
    "scikit-learn>=1.5" \
    "xarray>=2024.6" \
    "netcdf4>=1.7" \
    "h5netcdf>=1.3" \
    "dask>=2024.5" \
    "zarr>=2.18" \
    "bottleneck>=1.4" \
    "cartopy>=0.23" \
    "shapely>=2.0" \
    "pyproj>=3.6" \
    "esmf=8.6.0" \
    "esmpy=8.6.0" \
    "xesmf>=0.8.7" \
    matplotlib=3.10.8 \
    seaborn=0.13.2 \
    "packaging<=24.2" \
    && mamba clean -afy

ENV ESMFMKFILE=/opt/conda/lib/esmf.mk

# Install TensorFlow with GPU support via pip
# It will use the CUDA 12.9 and cuDNN 9 from the base image
RUN pip install --no-cache-dir tensorflow[and-cuda]==2.18

CMD ["jupyterhub-singleuser"]