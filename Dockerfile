# Base image
FROM nvidia/dcgm:4.1.1-1-ubuntu22.04

# Install basic dependencies
RUN apt-get update && apt-get install -y \
  git \
  python3 \
  python3-pip \
  python3-dev \
  # wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create symbolic links for python
RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip


# Set CUDA environment variables
# ENV PATH="/usr/local/cuda-12.8/bin:${PATH}"
# ENV LD_LIBRARY_PATH="/usr/local/cuda-12.8/lib64:${LD_LIBRARY_PATH}"
# ENV CUDA_HOME="/usr/local/cuda-12.8"

# Install PyTorch with CUDA 12.8 support (using nightly/preview build)
RUN pip install --no-cache-dir torch==2.8.0+cu128 --index-url https://download.pytorch.org/whl/cu128

# ARG NSYS_URL=https://developer.nvidia.com/downloads/assets/tools/secure/nsight-systems/2025_2/NsightSystems-linux-cli-public-2025.2.1.130-3569061.deb
# ARG NSYS_PKG=NsightSystems-linux-cli-public-2025.2.1.130-3569061.deb
# RUN apt-get update && apt install -y wget libglib2.0-0
# RUN wget ${NSYS_URL}${NSYS_PKG} && dpkg -i $NSYS_PKG && rm $NSYS_PKG


# Verify installations
RUN python --version && \
    git --version && \
    nvcc --version && \
    python -c "import torch; print('PyTorch version:', torch.version); print('CUDA available:', torch.cuda.is_available()); print('CUDA version:', torch.version.cuda if torch.cuda.is_available() else 'N/A')"

# Set working directory
WORKDIR /workspace
