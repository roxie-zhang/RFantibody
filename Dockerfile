FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu22.04
ARG DEBIAN_FRONTEND=noninteractive

# Base tools & Python 3.10 (22.04’s default), plus libcap2-bin for stripping caps
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-venv python3-pip \
      git wget curl ca-certificates vim make \
      libcap2-bin \
    && rm -rf /var/lib/apt/lists/*

# Virtualenv + poetry
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip && pip install poetry

WORKDIR /home

# Strip Linux file capabilities so enroot can import cleanly
RUN getcap -r / 2>/dev/null | awk '{print $1}' | xargs -r -n1 setcap -r || true

ENTRYPOINT ["/bin/bash"]
