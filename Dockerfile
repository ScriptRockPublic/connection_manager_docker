################################################################
# Dockerfile to run ScriptRock Agent / Connection Manager
#
# For public release; do not include any API keys or key-pairs
################################################################

# Set the base image to use to Ubuntu
FROM ubuntu:14.04

# Set the file maintainer
MAINTAINER Mark Sheahan <mark.sheahan@scriptrock.com>

# Create scriptrock user
RUN useradd --create-home scriptrock

# Update the sources list, add ScriptRock apt repository.
RUN apt-get update
RUN apt-get install -y --no-install-recommends curl
RUN curl http://download.scriptrock.com/apt/scriptrock.gpg.pub | sudo apt-key add -
RUN sudo /bin/sh -c 'echo "deb http://download.scriptrock.com/apt ubuntu main" > /etc/apt/sources.list.d/scriptrock.list'
RUN ls -l
RUN apt-get update
# Specify ScriptRock utility explicitly. This will continually change,
# and the commit to Github will trigger the DockerHub build
RUN apt-get install -y scriptrock=2.7.12-5

# Create ~/.scriptrock, and mount points for shared dirs
RUN ln -s /mnt/scriptrock_conf /home/scriptrock/.scriptrock
VOLUME ["/mnt/scriptrock_conf", "/mnt/scriptrock_logs"]

# run the agent in interactive mode
USER scriptrock
ENV HOME /home/scriptrock
WORKDIR /opt/scriptrock/
ENTRYPOINT /bin/bash -c '/opt/scriptrock/bin/sr interactive'

