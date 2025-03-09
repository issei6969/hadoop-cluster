FROM apache/hadoop:3

USER root

# Update YUM repository URLs to use CentOS Vault and install 'make'
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g; s|^#baseurl=|baseurl=|g' /etc/yum.repos.d/CentOS-*.repo && \
    sed -i 's|mirror.centos.org|vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo && \
    yum clean all && \
    yum update -y && \
    yum install -y make && \
    yum clean all && \
    echo "Installation of make completed."

# Switch back to non-root user
USER hadoop