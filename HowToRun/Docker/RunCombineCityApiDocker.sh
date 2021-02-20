#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED ***
***************
'
    echo "An error occurred in RunCombineCityApiDocker.sh . Exiting..." >&2
    exit 1
}

trap 'abort' 0
# It will trap the error and give us the instant suggetion "ABORTED"
set -e


LEVEL=NONDEBUG
if [ "$LEVEL" == "DEBUG" ]; then
	echo "Level is DEBUG"
	read levelIsDebug	
else
	echo "Level is NOT DEBUG. There will be no wait"	
fi
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
echo "Trying to login. If you are NOT logged in, there will be a prompt"
# docker login

cd ../../
pwd
# DONE: Please login before running the script, if you get an error.
echo "First we need to do the docker login"
docker login
#RunCombineCityApiDocker.sh
CURRENT_DIR=`pwd`
CURRENT_DATE=`date +%b-%d-%y_%I_%M_%S_%p`
mkdir logs/$CURRENT_DATE
echo "Starting sa-logic"
cd sa-logic
# TODO move it to how to run the directories.
sh BuildSa-logicDocker.sh > ../logs/sa-logic.log
#sh InstallSaLogicDocker.sh
echo "Started sa-logic. Do tail -f logs/sa-logic.log from "+$CURRENT_DIR
#open -a Terminal $CURRENT_DIR/logs

# If we got any error then it will trap us otherwise it will print successfully run your shell file

trap : 0

echo >&2 '
************
*** DONE RunCombineCityApiDocker ***
************'