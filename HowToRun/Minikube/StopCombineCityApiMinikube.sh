#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED StopCombineCityApiMinikube.sh ***
***************
'
    echo "An error occurred in StopTranslatorMinikube.sh . Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e
# Switch to root folder and run.
cd ../../
echo '1/4: Reset Docker to prevent connection error'
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
docker login 

echo '2/4: Deleting Deployments'
kubectl get deployments
kubectl delete deployment api --ignore-not-found
kubectl get Services

echo '3/4: Deleting Services'
kubectl delete service api --ignore-not-found
minikube service list

echo '3/4: Stopping Minikube'
minikube stop
echo '4/4: Minikube Status'
# INFO: bug fixed in https://github.com/kubernetes/minikube/issues/6814
# minikube status
# After stopping when you do status, it returns non-zero.
echo "DONE"

trap : 0

echo >&2 '
************
*** DONE StopCombineCityApiMinikube ***
************'