.PHONY: help build-all build-hub build-pytorch build-tensorflow clean

help:
	@echo "JupyterHub Docker Image Build Commands"
	@echo ""
	@echo "Usage:"
	@echo "  make build-all        - Build all images (hub + notebooks)"
	@echo "  make build-hub        - Build JupyterHub server image only"
	@echo "  make build-pytorch    - Build NVIDIA PyTorch notebook image"
	@echo "  make build-tensorflow - Build NVIDIA TensorFlow notebook image"
	@echo "  make clean            - Remove old images (use with caution)"
	@echo ""

build-all: build-hub build-pytorch build-tensorflow
	@echo "✓ All images built successfully"

build-hub:
	@echo "Building JupyterHub server image..."
	docker compose build hub

build-pytorch:
	@echo "Building NVIDIA PyTorch notebook image..."
	docker build -t jupyterhub-nvidia-pytorch:latest images/nvidia-pytorch/

build-tensorflow:
	@echo "Building NVIDIA TensorFlow notebook image..."
	docker build -t jupyterhub-nvidia-tensorflow:latest images/nvidia-tensorflow/

build-alphatauri:
	@echo "Building JupyterHub Alpha server image..."
	docker build -t jupyterhub-images-alphatauri:latest images/alphatauri/

clean:
	@echo "Cleaning up old images..."
	@echo "Warning: This will remove dangling images"
	docker image prune -f
