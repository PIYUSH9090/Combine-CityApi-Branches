#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED StopCombineCityApiDocker.sh Docker ***
***************
'
    echo "An error occurred in StopCombineCityApiDocker.sh docker . Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e

# To stop all running containers use the docker container stop command
# followed by a list of all containers IDs.
# TODO: add steps...or do i need this to be pretty ?
# TODO: add trap and abort ? or do i care about stop ?
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
cd ../../
echo "Listing All Containers:"
docker container ls -a
docker container stop $(docker container ls -aq )
echo "After Stopping All Containers:"
docker container ls -a
# Once all containers are stopped you can remove them using the
# docker container stop command followed by the containers ID list.
docker container rm $(docker container ls -aq)
echo "After Removing All Containers:"
docker container ls -a
# INFO: https://stackoverflow.com/questions/30604846/docker-error-no-space-left-on-device
echo "Docker system pruning:"
docker system prune -f
echo "After Pruning All Containers:"
docker container ls -a

trap : 0

echo >&2 '
************
*** DONE StopCombineCityApiDocker ***
************'
