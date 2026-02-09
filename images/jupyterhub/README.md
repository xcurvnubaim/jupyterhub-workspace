# JupyterHub Server Image

This is the main JupyterHub server image configured with DockerSpawner and internal SSL support.

## Components

- **Base Image**: `quay.io/jupyterhub/jupyterhub:5`
- **Spawner**: DockerSpawner (spawns notebook containers)
- **Authenticator**: NativeAuthenticator (local user management)

## Build

The image is built automatically by docker-compose:

```bash
docker compose build hub
```

Or build manually:

```bash
docker build -t jupyterhub:internal-ssl images/jupyterhub/
```

## Configuration

The hub configuration is mounted from the project root:
- `jupyterhub_config.py` - Main JupyterHub configuration

## Dependencies

See [requirements.txt](requirements.txt) for Python package dependencies.
