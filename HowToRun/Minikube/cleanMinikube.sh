#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED cleanMinikube.sh ***
***************
'
    echo "An error occurred in cleanMinikube.sh . Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e
minikube start
minikube stop
# My mac has 8 core 
minikube start --memory 10240 --cpus=4
echo '1/1: Is Minikube running ?'

trap : 0

echo >&2 '
************
*** DONE CleanMinikube ***
************'