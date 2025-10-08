# Base image
FROM nvidia/dcgm:4.1.1-1-ubuntu22.04

# Install git and Python 3
RUN apt-get update && apt-get install -y \
  git \
  python3 \
  python3-pip \
  python3-dev \
  wget \
  vim \
  nano \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create symbolic links for python
RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

RUN apt-get install cuda-toolkit-12-8

# Verify installations
RUN python --version && \
    git --version && \
    python -c "import torch; print('PyTorch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available()); print('CUDA version:', torch.version.cuda if torch.cuda.is_available() else 'N/A')"

# Set working directory
WORKDIR /workspace
