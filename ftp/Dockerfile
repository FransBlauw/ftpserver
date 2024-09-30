# Use the official Pure-FTPd image as the base
FROM stilliard/pure-ftpd:latest

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN touch /etc/pure-ftpd/pureftpd.passwd && \
    touch /etc/pure-ftpd/pureftpd.pdb

# Expose passive ports (ensure they match docker-compose ports)
ENV FTP_PORT=21
ENV FTP_PASSIVE_MIN=30000
ENV FTP_PASSIVE_MAX=30009

# Default command
CMD ["/entrypoint.sh"]
