c = get_config()

# Shutdown kernel after 30 minutes idle
c.MappingKernelManager.cull_idle_timeout = 3600

# Check every 60 seconds
c.MappingKernelManager.cull_interval = 60

# 🔥 This is the key line
c.MappingKernelManager.cull_connected = True

# Optional: shutdown server when no kernels & inactive
c.ServerApp.shutdown_no_activity_timeout = 3600