# Use 15.10 base
FROM ubuntu:15.10

# By Shane Francis
MAINTAINER Shane Francis <bigbeeshane@gmail.com>

# Update apt and get build reqs
RUN apt-get update
RUN apt-get install -y bc bison build-essential curl flex git gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 libxml2-utils lzop maven openjdk-7-jdk openjdk-7-jre pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev g++-multilib gcc-multilib lib32ncurses5-dev lib32readline6-dev lib32z1-dev sudo

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

# Download make 3.81 (Make 4.0 kills build speed when lots of CPUs are used)
ADD http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/make/make-3.81.tar.gz /home/${USER}/make-3.81.tar.gz

# Extract, build and install make
RUN tar -zxvf make-3.81.tar.gz && cd make-3.81 && ./configure && make && make install-exec

# Remove old make src files
RUN rm -rf make*

# Fix permissions on home
RUN chown -R ${USER}:${USER} /home/${USER}

USER ${USER}

# Setup dummy git config
RUN git config --global user.name "${USER}" && git config --global user.email "${USER}@localhost"
