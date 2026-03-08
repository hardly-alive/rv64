# Use Ubuntu 22.04 as the base
FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    bc \
    bison \
    flex \
    libgoogle-perftools-dev \
    perl \
    python3 \
    python3-pip \
    git \
    help2man \
    ca-certificates \
    device-tree-compiler \
    libexpat1-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Install RISC-V Toolchain (RV64)
RUN apt-get update && apt-get install -y gcc-riscv64-unknown-elf

# 3. Install Verilator (Latest stable via source for best compatibility)
RUN git clone https://github.com/verilator/verilator && \
    cd verilator && \
    git checkout v5.002 && \
    autoconf && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf verilator

# 4. Install Spike (ISA Simulator)
RUN git clone https://github.com/riscv-software-src/riscv-isa-sim.git && \
    cd riscv-isa-sim && \
    mkdir build && cd build && \
    ../configure --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    cd ../.. && rm -rf riscv-isa-sim

# Set the working directory inside the container
WORKDIR /work

# Default command: show the tool versions to verify install
CMD ["/bin/bash"]