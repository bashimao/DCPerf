#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- $(dirname -- ${BASH_SOURCE[0]}) &> /dev/null && pwd)
cd $SCRIPT_DIR

IMAGE="dcperf:24.04"
cd docker
docker build -t $IMAGE -f Dockerfile . || exit 1
cd ..

DOCKERFILE="
FROM $IMAGE

# Create a sudo-capable user that conveniently has the same UID and GID as our user.
# This way, any files created in the mounted filesystem belong to us.
RUN groupadd -g $(id -g) $USER
RUN useradd -u $(id -u) -g $(id -g) $USER && \
    echo $USER:$USER | chpasswd && \
    adduser $USER sudo
RUN sed -i 's/^%sudo/$USER    ALL=(ALL:ALL) ALL\nsudo/g' /etc/sudoers
"

IMAGE="dcperf-$USER:24.04"
echo "$DOCKERFILE" | docker build -t $IMAGE - || exit 1

VIDEO_DATA_DIRECTORY="/home/$USER/data/frames_y4m"

# Since we got a user that has our ID and credentials. We can mount our home
# directory to get access to our command history. Anyhow, you likely want to
# move the data directory to let it point somewhere proper.
docker run -it --rm \
  --privileged \
  --user $(id -u):$(id -g) \
  --volume $SCRIPT_DIR:/dcperf \
  --volume /home/$USER/data:/data \
  $IMAGE
  /bin/bash