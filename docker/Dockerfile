FROM ubuntu:24.04

ARG TARGETARCH

RUN apt-get clean && \
    apt-get update

# Base stuff we want to have around.
RUN apt-get install -y --no-install-recommends \
      adduser \
      linux-tools-common \
      linux-tools-generic \
      sudo && \
    if [[ "${TARGETARCH}" = "arm64" ]]; then \
    apt-get install --no-install-recommends \
      linux-tools-nvidia-64k-6.8 \
    ; fi

# Needed to run benchpress.
RUN apt-get install -y --no-install-recommends \
    bc \
    dmidecode \
    lshw \
    python3-click \
    python3-yaml \
    python3-tabulate \
    python3-numpy \
    python3-pandas

WORKDIR /dcperf