FROM condaforge/linux-anvil-aarch64:latest

USER root

# Install Miniconda if not already installed
RUN if [ ! -d "/opt/conda" ]; then \
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh && \
    /bin/sh Miniconda3-latest-Linux-aarch64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-aarch64.sh && \
    echo "export PATH=/opt/conda/bin:$PATH" >> ~/.bashrc; \
fi

# Create a conda environment and activate it
COPY env.yml env.yml
RUN /opt/conda/bin/conda env create -f env.yml
RUN echo "source activate $(head -1 env.yml | cut -d' ' -f2)" > ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

# Set up the working directory
WORKDIR /opt/demo_azure

# Copy files
COPY run.sh run.sh
COPY Gi3-cheat Gi3-cheat

# Set permissions
RUN chmod a+x run.sh

# Set the default command to run.sh
CMD ["./run.sh"]

