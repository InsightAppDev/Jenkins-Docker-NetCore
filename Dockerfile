FROM jenkins/jenkins:lts
# Switch to root to install .NET Core SDK
USER root

# Based on instructiions at https://docs.microsoft.com/en-us/dotnet/core/linux-prerequisites?tabs=netcore2x
# Install depency for dotnet core 2.2.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl libunwind8 gettext apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnetdev.list' && \
    apt-get update

# Install the .Net Core framework, set the path, and show the version of core installed.
RUN apt-get install -y dotnet-sdk-2.2 && \
    export PATH=$PATH:$HOME/dotnet && \
    dotnet --version

# Install vim
RUN apt-get install -y vim

# Install sudo
RUN apt-get install -y sudo
# Add jenkins to sudo
RUN usermod -aG sudo jenkins
# Disable password sudo for jenkins
RUN echo 'jenkins ALL=(ALL) NOPASSWD: /usr/bin/docker' >> /etc/sudoers

# Good idea to switch back to the jenkins user.
USER jenkins
