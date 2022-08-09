FROM centos:latest
 
ARG src_path
ENV src_path=$src_path
 
RUN cd /etc/yum.repos.d &&\
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&\
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* &&\
    yum update -y && \
    yum install -y wget initscripts && \
    yum install -y cronie && \
    yum clean all && \
    sed -i -r '/session\s+required\s+pam_loginuid.so/d' /etc/pam.d/crond
 
# TO get components (i.e. --id=...) to install, run the following command: ./CyberProtect_AgentForLinux_x86_64.bin --components-list
# Install only --id="BackupAndRecoveryAgent" component:
RUN wget -O /tmp/AcronisBackup.x86_64 $src_path && \
    chmod 777 /tmp/AcronisBackup.x86_64 && \
    /tmp/AcronisBackup.x86_64 -a --skip-prereq-check --skip-registration --id="BackupAndRecoveryAgent" || true && \
    rm /tmp/AcronisBackup.x86_64
 
COPY start.sh /opt/start.sh
 
CMD ["/bin/bash", "/opt/start.sh"]
