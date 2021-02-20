#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED RunCombineCityApiMinikube.sh ***
***************
'
    echo "An error occurred in RunCombineCityApiMinikube.sh . Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e

LEVEL=NONDEBUG
if [ "$LEVEL" == "DEBUG" ]; then
	echo "Level is DEBUG.Press Enter"
else
	echo "Level is NOT DEBUG. There will be no wait"	
fi

#kubernatesDeployments.sh
# NOTE:INFO:
# you would have to delete minikube if you face an error.
# install java again by downloading from oracle. if system extension are blocked.
# After that restart the system.
# Switch to root folder and run.


cd ../../
minikube start --memory 10240 --cpus=4 
echo '1/20: Is Minikube running ?'
minikube status
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
docker ps

# It will switch to the sa-logic folder to run that shell file
cd sa-logic
# TODO move it to how to run the directories.
sh BuildSa-logicDocker.sh > ../logs/sa-logic.log

# Come again root folder
cd ../

CURRENT_DATE=`date +%b-%d-%y_%I_%M_%p`
echo "Starting At "$CURRENT_DATE

echo "3/20 Deleting previous deployments."
#TODO: invoke delete.
kubectl get deployments
kubectl delete deployments --all --ignore-not-found
kubectl get deployments
# TODO: invoke delete
kubectl get services
kubectl delete services --all --ignore-not-found
kubectl get services

# This will deploy the deployment .yaml
echo "4/20 Deploying sa-logic deployments."
kubectl apply -f resource-manifests/deployment.yaml --record
kubectl get deployments
kubectl get pods

# It will deploy the service of sentiment-analyse-logic container
echo "5/20 Deploying service-sa-logic services."
kubectl apply -f resource-manifests/sa-logic.yaml --record
kubectl get services
kubectl get pods
# This command will deploy this container to server we will redirect in browser 
echo "Lets check it in browser"
minikube service api-service


trap : 0

echo >&2 '
************
*** DONE RunCombineCityApiMinikube ***
************'