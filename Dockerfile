# Base image
FROM nvidia/dcgm:4.1.1-1-ubuntu22.04

# Install git and Python 3
RUN apt-get update && apt-get install -y \
  git \
  python3 \
  python3-pip \
  python3-dev \
  wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create symbolic links for python
RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# Install PyTorch with CUDA support
# Using PyTorch 2.1.0 which supports CUDA 12.1 
# (as CUDA 12.8 wasn't officially supported at the time of writing, 
# but PyTorch with CUDA 12.1 should work on CUDA 12.x)
RUN pip install --no-cache-dir torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --extra-index-url https://download.pytorch.org/whl/cu121

# Verify installations
RUN python --version && \
    git --version && \
    python -c "import torch; print('PyTorch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available()); print('CUDA version:', torch.version.cuda if torch.cuda.is_available() else 'N/A')"

# Set working directory
WORKDIR /workspace
