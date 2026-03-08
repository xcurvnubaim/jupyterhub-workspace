.PHONY: help build-all build-hub build-pytorch build-tensorflow clean build-alphatauri generate-cert

help:
	@echo "JupyterHub Docker Image Build Commands"
	@echo ""
	@echo "Usage:"
	@echo "  make build-all        - Build all images (hub + notebooks)"
	@echo "  make build-hub        - Build JupyterHub server image only"
	@echo "  make build-pytorch    - Build NVIDIA PyTorch notebook image"
	@echo "  make build-tensorflow - Build NVIDIA TensorFlow notebook image"
	@echo "  make build-alphatauri - Build JupyterHub Alpha server image"
	@echo "  make build-bolzano    - Build JupyterHub Bolzano server image"
	@echo "  make push-alphatauri  - Push JupyterHub Alpha server image"
	@echo "  make push-bolzano     - Push JupyterHub Bolzano server image"
	@echo "  make generate-cert    - Generate Let's Encrypt cert via Cloudflare DNS-01"
	@echo "  make generate-cert-selfsigned  - Generate self-signed cert (offline fallback)"
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
	docker build -t xcurvnubaim/jupyterhub-images-alphatauri:latest images/alphatauri/

push-alphatauri:
	docker push xcurvnubaim/jupyterhub-images-alphatauri:latest

build-bolzano:
	@echo "Building JupyterHub Bolzano server image..."
	docker build -t xcurvnubaim/jupyterhub-bolzano:latest images/bolzano/

push-bolzano:
	docker push xcurvnubaim/jupyterhub-bolzano:latest

# Generate Let's Encrypt SSL cert via Cloudflare DNS-01 challenge
# Requires: cloudflare.ini with API token (see cloudflare.ini.example)
# Usage: make generate-cert
DOMAIN ?= server-ta.zmarzuqi.dev
generate-cert:
	@test -f cloudflare.ini || (echo "ERROR: cloudflare.ini not found. Copy cloudflare.ini.example and add your API token." && exit 1)
	@mkdir -p certs letsencrypt
	@echo "Requesting Let's Encrypt certificate for $(DOMAIN) via Cloudflare DNS-01..."
	docker run --rm \
		-v $(PWD)/letsencrypt:/etc/letsencrypt \
		-v $(PWD)/cloudflare.ini:/etc/cloudflare.ini:ro \
		certbot/dns-cloudflare certonly \
		--dns-cloudflare \
		--dns-cloudflare-credentials /etc/cloudflare.ini \
		--non-interactive --agree-tos \
		--register-unsafely-without-email \
		-d $(DOMAIN)
	sudo cp letsencrypt/live/$(DOMAIN)/fullchain.pem certs/server.crt
	sudo cp letsencrypt/live/$(DOMAIN)/privkey.pem certs/server.key
	sudo sh -c 'cat certs/server.crt certs/server.key > certs/haproxy.pem'
	sudo chmod 644 certs/*
	@echo ""
	@echo "✓ Let's Encrypt certificate generated:"
	@echo "  Domain: $(DOMAIN)"
	@echo "  Files:  certs/haproxy.pem"
	@echo ""
	@echo "Restart HAProxy: docker compose restart haproxy"
	@echo "Access at: https://$(DOMAIN)"

# Generate self-signed SSL cert (fallback for offline/internal use)
# Usage: make generate-cert-selfsigned              (auto-detect IP)
#        make generate-cert-selfsigned IP=192.168.1.100
generate-cert-selfsigned:
	@mkdir -p certs
	$(eval IP ?= $(shell hostname -I | awk '{print $$1}'))
	$(eval SSLIP_DOMAIN := $(shell echo $(IP) | tr '.' '-').sslip.io)
	@echo "Generating self-signed certificate for $(SSLIP_DOMAIN) ($(IP))..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout certs/server.key \
		-out certs/server.crt \
		-subj "/CN=$(SSLIP_DOMAIN)" \
		-addext "subjectAltName=DNS:$(SSLIP_DOMAIN),DNS:*.$(SSLIP_DOMAIN),IP:$(IP)"
	@cat certs/server.crt certs/server.key > certs/haproxy.pem
	@echo ""
	@echo "✓ Self-signed certificate generated:"
	@echo "  Domain:  $(SSLIP_DOMAIN)"
	@echo "  IP:      $(IP)"
	@echo "  Files:   certs/server.crt, certs/server.key, certs/haproxy.pem"
	@echo ""
	@echo "Access JupyterHub at:"
	@echo "  https://$(SSLIP_DOMAIN)"
	@echo "  http://$(IP)"

clean:
	@echo "Cleaning up old images..."
	@echo "Warning: This will remove dangling images"
	docker image prune -f
