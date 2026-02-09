# JupyterHub with Docker Spawner and Internal SSL

A production-ready JupyterHub deployment with DockerSpawner and total internal SSL encryption.

## Features

- **Internal SSL**: All internal communication encrypted and authenticated
- **Docker Spawner**: Container-based user notebooks with GPU support
- **Multiple Images**: Pre-configured NVIDIA PyTorch and TensorFlow images
- **HAProxy**: Load balancing and SSL termination
- **Native Auth**: Local user management with NativeAuthenticator

## Quick Start

1. **Create Docker resources:**
   ```bash
   docker network create jupyterhub
   docker volume create jupyterhub-ssl
   docker volume create jupyterhub-data
   ```

2. **Build images:**
   ```bash
   # Build JupyterHub server
   make build-hub
   
   # Or build all images including notebooks
   make build-all
   ```

3. **Start services:**
   ```bash
   docker compose up
   ```

4. **Access JupyterHub:**
   Visit http://127.0.0.1:8000

## Project Structure

```
.
├── images/                    # Docker image definitions
│   ├── jupyterhub/           # JupyterHub server image
│   ├── nvidia-pytorch/       # PyTorch notebook image
│   └── nvidia-tensorflow/    # TensorFlow notebook image
├── docker-compose.yml        # Main service definitions
├── docker-compose.images.yml # Notebook image builds
├── jupyterhub_config.py      # JupyterHub configuration
├── haproxy.cfg              # HAProxy configuration
├── Makefile                 # Build automation
└── README.md               # This file
```

See [images/README.md](images/README.md) for detailed image documentation.

## Building Images

Use the Makefile for easy image builds:

```bash
make help                 # Show all available commands
make build-hub           # Build JupyterHub server
make build-pytorch       # Build PyTorch notebook image
make build-tensorflow    # Build TensorFlow notebook image
make build-all          # Build all images
```

Or use docker compose directly:

```bash
docker compose build hub
docker compose -f docker-compose.yml -f docker-compose.images.yml build
```

## Configuration

Configure your deployment by setting environment variables in `.env`:

- `DOCKER_NOTEBOOK_IMAGE`: Which notebook image to spawn (e.g., `jupyterhub/nvidia-pytorch:latest`)
- `CONFIGPROXY_AUTH_TOKEN`: Proxy authentication token
- `DOCKER_NETWORK_NAME`: Docker network name (default: `jupyterhub`)

## Adding Custom Images

See [images/README.md](images/README.md) for instructions on adding new notebook images.
