#!/bin/bash

# this test demonstrates using singleton in a bash script

set -eu

cmd=$1

wdir=$(mktemp -d)

trap "rm -rf $wdir" EXIT INT TERM

runs=100


for i in $(seq $runs) ; do 
    (
        $($cmd source)
        if lock_try test ; then
            echo "lock success"
            sleep 1
            lock_release
        else
            # lock failed
            echo "lock fail"
        fi
    )  > $wdir/$i.out 2>&1 &
done

wait 

fails=$(cat $wdir/*.out | grep "lock fail" | wc -l)
winner=$(cd $wdir && fgrep -rl "lock success" . )

echo winner is $winner
echo "$fails for $runs runs"

[[ $(($fails+1)) == $runs ]]
