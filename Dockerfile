FROM ubuntu:20.04

# update and install apps
RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends mc wget curl vim systemd sudo openssl
RUN apt-get -qq -y upgrade
RUN apt-get -qq clean && rm -rf /var/lib/apt/lists/*

# open ports
EXPOSE 8888

# change to student user pw="student"
RUN useradd -d /home/student -m -s/bin/bash -G sudo -p $(openssl passwd -1 student) student
RUN usermod -aG sudo student
USER student
WORKDIR /home/student/tmp

# install miniconda3
RUN wget "https://repo.anaconda.com/miniconda/Miniconda3-py39_23.1.0-1-Linux-x86_64.sh" --no-check-certificate
RUN chmod +x "./Miniconda3-py39_23.1.0-1-Linux-x86_64.sh"
RUN "./Miniconda3-py39_23.1.0-1-Linux-x86_64.sh" -b -f -p /home/student/miniconda3
RUN /home/student/miniconda3/bin/conda init --all

# Springboard-specific configuration
ENV REQ_FILE requirements2.txt
WORKDIR /home/student/SPRINGBOARD_FILES
RUN /home/student/miniconda3/bin/conda create -n springboard_env -c conda-forge python=3.9 mamba
RUN echo "conda activate springboard_env" >> ~/.bashrc
SHELL ["/home/student/miniconda3/bin/conda", "run", "-n", "springboard_env", "/bin/bash", "-c"]
ENV SHELL /bin/bash
COPY $REQ_FILE /tmp/$REQ_FILE
RUN mamba install -y -c conda-forge --file /tmp/$REQ_FILE

# run jupyter lab as default
RUN echo -e "student\nstudent\n" | jupyter lab password
ENTRYPOINT ["/home/student/miniconda3/envs/springboard_env/bin/jupyter", "lab", "--ip='*'", "--port=8888", "--no-browser", "--notebook-dir=/home/student/SPRINGBOARD_FILES"]
