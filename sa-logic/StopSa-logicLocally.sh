#StopSaLogicLocally.sh
#TODO rename to sentiment_analysis_logic
echo "Stop Sa Logic Locally"+ `date`
ps ax | grep sentiment_analysis | cut -f2 -d" " - | xargs kill -9
ps ax | grep sentiment_analysis | cut -f1 -d" " - | xargs kill -9
ps ax | grep sentiment_analysis | cut -f2 -d" " - | xargs kill -9
ps ax | grep sentiment_analysis | cut -f1 -d" " - | xargs kill -9
ps ax | grep sentiment_analysis