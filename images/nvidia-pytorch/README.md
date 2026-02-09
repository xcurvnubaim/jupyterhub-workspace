# NVIDIA PyTorch Notebook Image

This image is based on NVIDIA's official PyTorch container with JupyterHub integration.

## Build Arguments

- `PYTORCH_IMAGE`: The base NVIDIA PyTorch image (default: `nvcr.io/nvidia/pytorch:26.01-py3`)

## Build Example

```bash
docker build -t jupyterhub/nvidia-pytorch:latest \
  --build-arg PYTORCH_IMAGE=nvcr.io/nvidia/pytorch:26.01-py3 \
  images/nvidia-pytorch/
```

## Features

- NVIDIA CUDA support
- PyTorch deep learning framework
- JupyterHub single-user server
- Pre-configured jovyan user
