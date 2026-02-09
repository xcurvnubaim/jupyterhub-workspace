import os
import subprocess
import pathlib

c = get_config()  # noqa

c.JupyterHub.authenticator_class = 'nativeauthenticator.NativeAuthenticator'

# Allow anyone to sign-up without approval
c.NativeAuthenticator.open_signup = False

# Allow all signed-up users to login
c.Authenticator.allow_all = True

# Allowed admins
admin = os.environ.get("JUPYTERHUB_ADMIN")
if admin:
    c.Authenticator.admin_users = [admin]

c.JupyterHub.spawner_class = 'docker'

c.ConfigurableHTTPProxy.should_start = False
c.ConfigurableHTTPProxy.api_url = 'https://proxy:8001'

c.JupyterHub.internal_ssl = True

c.DockerSpawner.image = os.environ['DOCKER_NOTEBOOK_IMAGE']
c.DockerSpawner.remove_containers = True
c.JupyterHub.log_level = 10

c.JupyterHub.hub_ip = '0.0.0.0'
c.JupyterHub.hub_connect_ip = 'jupyterhub'
c.DockerSpawner.network_name = os.environ['DOCKER_NETWORK_NAME']
c.JupyterHub.internal_certs_location = os.environ['INTERNAL_SSL_PATH']
# c.JupyterHub.recreate_internal_certs = True
c.JupyterHub.trusted_alt_names = ["DNS:jupyterhub", "DNS:proxy"]

notebook_dir = os.environ.get("DOCKER_NOTEBOOK_DIR", "/home/jovyan/work")
c.DockerSpawner.notebook_dir = notebook_dir

# Create user directories on host before spawning

# Get the host path - /data in container maps to ./volume on host
# We need to use the absolute path on the host for Docker mounts
host_data_dir = os.environ.get('HOST_DATA_DIR', '/data')

def create_dir_hook(spawner):
    """Create user directory on host before spawning container"""
    username = spawner.user.name
    # Create directory inside the JupyterHub container at /data
    user_dir = pathlib.Path(f"/data/jupyterhub-user-{username}")
    user_dir.mkdir(parents=True, exist_ok=True)
    
    # Set ownership to users group (GID 100) and make it writable by group
    # This works for both standard images (UID 1000) and NVIDIA images (UID 1001)
    subprocess.run(['chgrp', '100', str(user_dir)], check=False)
    subprocess.run(['chmod', '775', str(user_dir)], check=False)

c.Spawner.pre_spawn_hook = create_dir_hook

# Mount a directory on the host to the notebook user's notebook directory in the container
# Note: This must be the actual host path, not the path inside jupyterhub container
c.DockerSpawner.mounts = [
    {'source': f'{host_data_dir}/jupyterhub-user-{{username}}', 'target': notebook_dir, 'type': 'bind'}
]

# Persist hub data on volume mounted inside container
c.JupyterHub.cookie_secret_file = "/data/jupyterhub_cookie_secret"
c.JupyterHub.db_url = "sqlite:////data/jupyterhub.sqlite"

# Selectable user environments via Docker images
c.DockerSpawner.allowed_images = [
    "quay.io/jupyterhub/singleuser:5.4",
    "jupyterhub-nvidia-tensorflow:local",
    "jupyterhub-nvidia-pytorch:local"
]

# Image labels for better UX
image_labels = {
    "quay.io/jupyterhub/singleuser:5.4": "JupyterHub Single User (Default)",
    "jupyterhub-nvidia-tensorflow:local": "NVIDIA TensorFlow 25.02",
    "jupyterhub-nvidia-pytorch:local": "NVIDIA PyTorch 26.01"
}

def get_options_form(spawner):
    """Generate form for image selection"""
    default_image = os.environ["DOCKER_NOTEBOOK_IMAGE"]
    
    options_html = ""
    for image in c.DockerSpawner.allowed_images:
        label = image_labels.get(image, image)
        selected = 'selected="selected"' if image == default_image else ''
        options_html += f'<option value="{image}" {selected}>{label}</option>\n'
    
    return f"""
    <label for="image">Select Image:</label>
    <select name="image" class="form-control">
        {options_html}
    </select>
    """

c.DockerSpawner.options_form = get_options_form

def options_from_form(options_form_data):
    """Process form data and configure spawner based on selected image"""
    options = {}
    
    # Get selected image from form
    image = options_form_data.get('image', [os.environ['DOCKER_NOTEBOOK_IMAGE']])[0]
    options['image'] = image
    
    return options

c.DockerSpawner.options_from_form = options_from_form