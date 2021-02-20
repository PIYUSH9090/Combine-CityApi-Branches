#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED BuildSaLogicDocker ***
***************
'
    echo "An error occurred BuildSaLogicDocker . Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e
# TODO make this as bash variable.
# TODO Make this on every file ?
LEVEL=NONDEBUG
if [ "$LEVEL" == "DEBUG" ]; then
	echo "Level is DEBUG.Press Enter to continue."
	read levelIsDebug	
else
	echo "Level is NOT DEBUG. There will be no wait."	
fi
#InstallSaLogicLocally.sh
#Kill the process
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
echo "Trying to login. If you are NOT logged in, there will be a prompt"
docker login

# It will print the log folder wise
echo "Building sentiment-analysis-logic"
docker build -f Dockerfile -t piyush9090/sentiment-analysis-logic .
# Now image building is done 
# So now we will push that image to dockerhub
echo "Pushing sentiment-analysis-logic"
docker push piyush9090/sentiment-analysis-logic
# Here we run the container with that port 5000:5000
echo "Running sentiment-analysis-logic"
docker run -d -p 5050:5000 piyush9090/sentiment-analysis-logic &
sleep 5
echo "List of containers running now"
docker container ls -a

saLogicId="$(docker container ls -f ancestor="piyush9090/sentiment-analysis-logic" -f status=running -aq)"
echo " The one we just started is : $saLogicId"

if [ -n "$saLogicId" ]; then
  echo "sentiment_analysis container is running $(docker container ls -f ancestor=piyush9090/sentiment-analysis-logic -f status=running -aq) :) "
else
  echo "ERROR: sentiment_analysis is NOT running. :(  . Please Check logs/sa-logic.log"
  exit 1
fi

trap : 0

echo >&2 '
************
*** DONE BuildSaLogicDocker ***
************'