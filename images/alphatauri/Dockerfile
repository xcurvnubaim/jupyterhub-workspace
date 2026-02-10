FROM condaforge/mambaforge:latest

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

# Install system libraries for Cartopy (Geospatial) and ESMF (Regridding)
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libxml2 \
    libopenmpi-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install the Scientific Stack
# We use Mamba because the dependency solving for Numpy 2.0 is complex
RUN mamba install -y -c conda-forge \
    # --- Core Python & Jupyter ---
    python=3.11 \
    jupyterhub=5.2.1 \
    jupyterlab=4.3.4 \
    jupyter-lsp \
    python-lsp-server \
    # --- The Big Update: Numpy 2.0 ---
    "numpy>=2.1" \
    # --- Scientific Libraries (Must be compatible with Numpy 2) ---
    "pandas>=2.2.2" \
    "scipy>=1.14" \
    "scikit-learn>=1.5" \
    # --- Climate Data Stack ---
    "xarray>=2024.6" \
    "netcdf4>=1.7" \
    "h5netcdf>=1.3" \
    "dask>=2024.5" \
    "zarr>=2.18" \
    "bottleneck>=1.4" \
    # --- Geospatial Stack ---
    "cartopy>=0.23" \
    "shapely>=2.0" \
    "pyproj>=3.6" \
    # --- Regridding (Critical for your ERA5/IFS work) ---
    "esmf=8.6.0" \
    "esmpy=8.6.0" \
    "xesmf>=0.8.7" \
    # --- Visualization ---
    matplotlib=3.10.8 \
    seaborn=0.13.2 \
    # --- GPU Support (RTX 6000 Ada) ---
    # Note: TensorFlow 2.16+ is required for Numpy 2.0
    "tensorflow-gpu=2.17" \
    "cuda-version=12.4" \
    "cuda-cudart=12.4" \
    "cudnn=9.10" \
    # --- Lab Admin Constraints ---
    "packaging<=24.2" \
    && mamba clean -afy

# Set environment variables for ESMF to find its definition file
ENV ESMFMKFILE=/opt/conda/lib/esmf.mk

# Create the user
RUN useradd -m -s /bin/bash -u 1000 jovyan && \
    chown -R jovyan:jovyan /opt/conda

USER jovyan
WORKDIR /home/jovyan
ENV PATH=/opt/conda/bin:$PATH

CMD ["jupyterhub-singleuser"]