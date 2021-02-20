#StopSaLogicDocker.sh
echo "List of containers running now"
docker container ls -a
echo "sentiment-analysis-logic container info"
docker container ls -f ancestor=piyush9090/sentiment-analysis-logic
echo "Stopping sentiment-analysis-logic container"
docker container stop $(docker container ls -f ancestor=piyush9090/sentiment-analysis-logic -aq)
# Once all containers are stopped you can remove them using the 
# docker container stop command followed by the containers ID list.
echo "Removing sentiment-analysis-logic container"
docker container rm $(docker container ls -f ancestor=piyush9090/sentiment-analysis-logic -aq)
echo "List of containers running now"
docker container ls -a