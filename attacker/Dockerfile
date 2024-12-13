FROM debian:latest

# update and install required tools
RUN apt-get update && apt-get install -y \
    bash \
    python3 \
    python3-pip \
    pipx \
    git \
    smbclient \
    net-tools \
    wget && \
    pipx ensurepath && \
    pipx install git+https://github.com/Pennyw0rth/NetExec

# install enum4linux
RUN apt-get install -y perl && \
    wget -O /usr/local/bin/enum4linux https://raw.githubusercontent.com/CiscoCXSecurity/enum4linux/master/enum4linux.pl && \
    chmod +x /usr/local/bin/enum4linux

# run the container
CMD ["/bin/bash"]
