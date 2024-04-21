# Use an official NVIDIA CUDA image with Ubuntu as the base
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set noninteractive installation mode
ENV DEBIAN_FRONTEND noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    git \
    python3 \
    python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Miniconda and OpenMM
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /miniconda && \
    rm /miniconda.sh && \
    /miniconda/bin/conda install -c conda-forge openmm -y

# Set the PATH environment variable
ENV PATH=/miniconda/bin:${PATH}

# Clone the OpenMM GitHub repository
RUN git clone https://github.com/openmm/openmm.git

# Set the working directory to the examples directory in the cloned repo
WORKDIR /openmm/examples

# Modify simulatePDB.py to run on a GPU (Assuming you have the script ready for modifications)
RUN sed -i 's/Simulation(pdb.topology, system, integrator)/Simulation(pdb.topology, system, integrator, Platform.getPlatformByName("CUDA"))/g' simulatePdb.py

# Default command to run the simulatePDB.py script
CMD ["python3", "simulatePdb.py"]
