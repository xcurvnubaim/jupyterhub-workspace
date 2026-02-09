# NVIDIA TensorFlow Notebook Image

This image is based on NVIDIA's official TensorFlow container with JupyterHub integration.

## Build Arguments

- `TENSORFLOW_IMAGE`: The base NVIDIA TensorFlow image (default: `nvcr.io/nvidia/tensorflow:25.02-tf2-py3`)

## Build Example

```bash
docker build -t jupyterhub/nvidia-tensorflow:latest \
  --build-arg TENSORFLOW_IMAGE=nvcr.io/nvidia/tensorflow:25.02-tf2-py3 \
  images/nvidia-tensorflow/
```

## Features

- NVIDIA CUDA support
- TensorFlow 2.x deep learning framework
- JupyterHub single-user server
- Pre-configured jovyan user
