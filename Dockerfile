# Use 16.04 base
FROM ubuntu:16.04

# By Shane Francis
MAINTAINER Shane Francis <bigbeeshane@gmail.com>

# Update apt and get build reqs
RUN apt-get update && apt-get install -y bc bison build-essential curl flex git gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libxml2 libxml2-utils lzop maven openjdk-8-jdk openjdk-8-jre pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev g++-multilib gcc-multilib lib32ncurses5-dev lib32readline6-dev lib32z1-dev sudo automake python-networkx bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev dpkg-dev make optipng

# Download Repo
ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

# Switch to the new user by default and make ~/ the working dir
ENV USER build
WORKDIR /home/${USER}/

# Add the build user, update password to build and add to sudo group
RUN useradd --create-home ${USER} && echo "${USER}:${USER}" | chpasswd && adduser ${USER} sudo

# Use ccache by default
ENV USE_CCACHE 1

# Use the shared volume for ccache storage
ENV CCACHE_DIR /home/build/aosp/.ccache

# Fix permissions on home
RUN chown -R ${USER}:${USER} /home/${USER}

USER ${USER}

# Setup dummy git config
RUN git config --global user.name "${USER}" && git config --global user.email "${USER}@localhost"
