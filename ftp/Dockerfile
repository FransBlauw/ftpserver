# Use the official Pure-FTPd image as the base
FROM stilliard/pure-ftpd:latest

# Install necessary packages
# RUN apt-get update && apt-get install -y \
#     bash \
#     && rm -rf /var/lib/apt/lists/*

# Create ftpuser group and user
RUN groupadd ftpuser
#     useradd -g ftpuser -s /bin/bash ftpuser

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose passive ports (ensure they match docker-compose ports)
ENV FTP_PORT=21
ENV FTP_PASSIVE_MIN=30000
ENV FTP_PASSIVE_MAX=30009

# Set environment variables for Pure-FTPd
ENV PUBLICHOST=host.com

# Default command
CMD ["/entrypoint.sh"]
