# Docker Images

This directory contains all Docker image definitions for the JupyterHub deployment.

## Directory Structure

```
images/
├── jupyterhub/              # JupyterHub server image
│   ├── Dockerfile
│   ├── requirements.txt
│   └── .dockerignore
├── nvidia-pytorch/          # NVIDIA PyTorch notebook image
│   ├── Dockerfile
│   └── README.md
└── nvidia-tensorflow/       # NVIDIA TensorFlow notebook image
    ├── Dockerfile
    └── README.md
```

## Images

### JupyterHub Server (`jupyterhub/`)

The main JupyterHub server image with:
- DockerSpawner for container-based notebooks
- Native authenticator for user management
- SSL certificate generation support

**Build:**
```bash
docker compose build hub
```

### NVIDIA PyTorch (`nvidia-pytorch/`)

GPU-enabled notebook environment with PyTorch. Based on NVIDIA's official PyTorch container.

**Build:**
```bash
docker build -t jupyterhub/nvidia-pytorch:latest images/nvidia-pytorch/
```

### NVIDIA TensorFlow (`nvidia-tensorflow/`)

GPU-enabled notebook environment with TensorFlow 2.x. Based on NVIDIA's official TensorFlow container.

**Build:**
```bash
docker build -t jupyterhub/nvidia-tensorflow:latest images/nvidia-tensorflow/
```

## Adding New Images

To add a new notebook image:

1. Create a new directory under `images/` (e.g., `images/my-custom-image/`)
2. Add a `Dockerfile` with your image definition
3. Ensure the image includes:
   - `jupyterhub` package matching the hub version
   - `notebook` or `jupyterlab` package
   - `CMD ["jupyterhub-singleuser"]`
4. (Optional) Add a `README.md` documenting the image
5. Build the image and set it as `DOCKER_NOTEBOOK_IMAGE` in your `.env` file

## Build Arguments

Each image supports build arguments for customization. See individual image READMEs for details.

## Best Practices

- Keep image contexts minimal by using `.dockerignore`
- Version pin critical dependencies
- Document build arguments and environment variables
- Test images locally before deployment
- Use multi-stage builds where appropriate to reduce image size
