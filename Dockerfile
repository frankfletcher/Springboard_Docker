FROM ubuntu:latest

MAINTAINER cogsci2@gmail.com

# update and install apps
RUN apt-get update
RUN apt-get install -y wget curl git vim graphviz
WORKDIR /tmp

# install miniconda3
RUN wget "https://repo.anaconda.com/miniconda/Miniconda3-py39_23.1.0-1-Linux-x86_64.sh"
RUN mkdir /opt/miniconda3
RUN chmod +x "./Miniconda3-py39_23.1.0-1-Linux-x86_64.sh"
RUN "./Miniconda3-py39_23.1.0-1-Linux-x86_64.sh" -b -f -p /opt/miniconda3
RUN /opt/miniconda3/bin/conda init --all


# Springboard-specific configuration
WORKDIR /SPRINGBOARD_FILES
COPY requirements.txt /tmp/requirements.txt
RUN /opt/miniconda3/bin/conda create -n springboard_env python=3.9
RUN echo "conda activate springboard_env" >> ~/.bashrc
SHELL ["/opt/miniconda3/bin/conda", "run", "-n", "springboard_env", "/bin/bash", "-c"]
RUN pip install -r /tmp/requirements.txt
