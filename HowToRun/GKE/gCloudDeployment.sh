echo >&2 '
***************
*** Lets create a deploymentCityApi.sh ***
***************
'
 >&2

# We are creating shell script for deployment of this city_api project 

echo "First we need to do the docker login"
docker login
docker ps

DOCKERIMAGE=combine_city_api_process
DOCKERREPO=piyush9090/$DOCKERIMAGE
echo "Building image named DOCKERIMAGE"
docker build -t $DOCKERIMAGE .
echo "Pushing the image $DOCKERIMAGE"
echo "you have to push it in your dockerhub account"
docker image tag $DOCKERIMAGE $DOCKERREPO
docker push $DOCKERREPO

# Before this step you should have already project created in gcloud and also you have enable the api and services in the kubernates engine api
echo "Before creating new deployment we need to remove old deployments"
kubectl delete deployment api
kubectl delete pods

echo "SA logic deployment."
kubectl apply -f deployment.yaml --record
kubectl get deployments
kubectl get pods

echo "Before creating new service we need to remove old services"
kubectl delete service api-service

echo "logic service."
kubectl apply -f sa-logic.yaml --record
kubectl get services
kubectl get pods
kubectl get service api-service


 echo >&2 '
************
*** DONE deploymentCityApi.sh ***
************'