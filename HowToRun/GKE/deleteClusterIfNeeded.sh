#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED deleteClusterIfNeeded.sh ***
***************
'
    echo "An error occurred in deleteClusterIfNeeded.sh . Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e
# TODO: this script is broken.
# TODO: Check gCloud has the cluster. If present then delete.
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
# INFO: https://stackoverflow.com/questions/30604846/docker-error-no-space-left-on-device
echo "INFO: Docker system pruning to save space:"
CLUSTERNAME=cityapiprocess
docker system prune -f

CLUSTERNAME_EXIST=$(kubectl config get-contexts -o name | grep $CLUSTERNAME_NAME | wc -c)
echo "Do clusters exist?-" $CLUSTERNAME_EXIST
if [[ CLUSTERNAME_EXIST -ne 0 ]]; then
	CLUSTERNAME_FOUND=`kubectl config get-contexts -o name | grep $CLUSTERNAME_NAME`
	# gke_CLUSTERNAME-258700_us-central1-f_CLUSTERNAME3
	echo "The cluster to be deleted is :"$CLUSTERNAME_FOUND
	kubectl config delete-cluster $CLUSTERNAME_FOUND
	echo "Deleted the cluster :"$CLUSTERNAME_FOUND
	kubectl config delete-context $CLUSTERNAME_FOUND
	echo "Deleted the cluster context:"$CLUSTERNAME_FOUND
	echo "gcloud container clusters delete $CLUSTERNAME_FOUND -q --async"
	# INFO: when you try to do things parallely, then contexts will be deleted but not the cluster. 
	gcloud container clusters delete $CLUSTERNAME_NAME
	echo "deletion of gcloud cluster is in progress...in background."
else
	echo "No clusters to delete"
fi

trap : 0

echo >&2 '
************
*** DONE deleteClusterIfNeeded ***
************'