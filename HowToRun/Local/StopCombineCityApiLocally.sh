#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED ***
***************
'
    echo "An error occurred StopCombineCityApiLocally.sh . Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e
cd ../../
cd sa-logic
sh StopSa-logicLocally.sh >> ../logs/sa-logic.log
echo "Stopped sa-logic. Do tail -f logs/sa-logic.log from "+$CURRENT_DIR

trap : 0

echo >&2 '
************
*** DONE StopCombineCityApiLocally ***
************'
