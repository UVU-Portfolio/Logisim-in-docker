# Use Ubuntu 22.04 as the base image for stability and reproducibility
FROM ubuntu:22.04

# Update package lists, install required dependencies, download Logisim,
# clean up to reduce image size, and create a non-root user
RUN apt-get update && \
    apt-get install -y openjdk-11-jre wget && \
    wget https://sourceforge.net/projects/circuit/files/2.7.x/2.7.1/logisim-generic-2.7.1.jar -O /opt/logisim.jar && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m logisim

# Set environment variables for Java
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

# Set the working directory to the logisim user's home directory
WORKDIR /home/logisim

# Switch to the non-root user for improved security
USER logisim

# Add a health check to ensure Java process is running
HEALTHCHECK CMD pgrep java || exit 1

# Set the entrypoint to run Logisim
ENTRYPOINT ["java", "-jar", "/opt/logisim.jar"]

# Allow passing additional arguments to Java/Logisim
CMD []