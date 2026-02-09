ARG JUPYTERHUB_VERSION=5
FROM quay.io/jupyterhub/jupyterhub:$JUPYTERHUB_VERSION

# Install required Python packages
COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --no-cache -r /tmp/requirements.txt


CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
