FROM alpine:latest

# If your script uses bash, install it first
RUN apk add --no-cache bash

# Copy the script into the image
COPY DockerTestScript.sh /

# Run the script when the container starts
CMD ["/bin/sh", "/DockerTestScript.sh"]
