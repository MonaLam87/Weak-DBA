# Use official Ubuntu base image
FROM ubuntu:24.04

LABEL maintainer="luwaymma@outlook.com"

ENV TZ=Europe/London
ENV DEBIAN_FRONTEND=noninteractive

# Update and install Java, Python, and editors/viewers
RUN apt-get update && \
    apt-get install -y \
    openjdk-11-jdk \
    python3 \
    python3-pip \
    vim \
    nano \
    less \
    time \
    procps \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Set working directory
WORKDIR /workspace

# Copy everything into /workspace
COPY . .

# Make all scripts in Experiments executable
RUN find /workspace/Experiments -type f \( -name "*.sh" -o -name "*.py" \) -exec chmod +x {} \;

# Debug: confirm contents
RUN ls -l /workspace/Experiments && ls -l /workspace/Experiments/wdba

# Default shell
CMD ["bash"]
