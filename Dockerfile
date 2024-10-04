# syntax = docker/dockerfile:1.2

FROM paperspace/gradient-base:pt211-tf215-cudatk120-py311-20240202

SHELL ["/bin/bash", "-c"] 
WORKDIR /root

# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_network
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb

RUN rm -f /etc/apt/apt.conf.d/docker-clean
RUN --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y \
    cuda-toolkit-12-6

RUN python -m venv create jupyter
ENV PATH="/root/jupyter/bin:$PATH"

RUN pip install \
    ipykernel \
    ipywidgets \
    matplotlib

COPY run.sh .
RUN chmod +x run.sh

CMD ["/root/run.sh"]