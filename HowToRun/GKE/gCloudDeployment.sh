if [ "$LEVEL" == "DEBUG" ]; then
	echo "Level is DEBUG. Press enter when paused"
else
	echo "Level is NOT DEBUG. There will be no wait"	
fi
cd ../../

# We are creating shell script for deployment of this city_api project 
echo 'Reset Docker to prevent connection error'
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
echo "First we need to do the docker login"
docker login
docker ps

echo 'Create the cluster from scratch if necessary.[OPTIONAL]'
sh createClusterIfNeeded.sh

echo "Building sa-logic component in no hup mode"
cd sa-logic
# TODO move it to how to run the directories.
sh BuildSa-logicDocker.sh > ../logs/sa-logic.log
cd ../

CURRENT_DATE=`date +%b-%d-%y_%I_%M_%p`
echo "Starting At "$CURRENT_DATE
echo "Deleting Deployments"
kubectl get deployments

# Before this step you should have already project created in gcloud and also you have enable the api and services in the kubernates engine api
echo "Before creating new deployment we need to remove old deployments"
kubectl delete deployment api
kubectl delete pods

echo "Before creating new service we need to remove old services"
kubectl get services
kubectl delete service api-service
kubectl get services

if [ "$LEVEL" == "DEBUG" ]; then
	echo "Press Enter if sa-logic is pushed to docker hub."
	read saLogicIsPushed
else
	echo 'sa-logic pushed.'	
fi

echo "deployment."
kubectl apply -f resource-manifests/deployment.yaml --record
kubectl get deployments
kubectl get pods

echo "sa-logic service."
kubectl apply -f resource-manifests/sa-logic.yaml
kubectl get services
kubectl get pods
kubectl get service api-service

echo 'Check rollout status.'	
# INFO: This is to prevent silent Errors.
kubectl rollout status deployment sa-logic


echo "combinecityapi service."
combinecityapiIp=""
combinecityapiPort=""
while [ -z $combinecityapiIp ]; do
    sleep 5
    kubectl get svc
    combinecityapiIp=`kubectl get service api-service --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'`
	combinecityapiPort=`kubectl get service api-service --output=jsonpath='{.spec.ports[0].port}'`
done

echo "launch "$combinecityapiIp":"$combinecityapiPort


trap : 0

 echo >&2 '
************
*** DONE deploymentCityApi.sh ***
************'
