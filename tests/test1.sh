#!/bin/bash

set -eu

cmd=$1

wdir=$(mktemp -d)

trap "rm -rf $wdir" EXIT INT TERM

runs=100

for i in $(seq $runs) ; do 
    $cmd test eval "sleep 1 ; echo lock success" > $wdir/$i.out 2>&1 &
done

wait 

fails=$(cat $wdir/*.out | grep "Another process" | wc -l)

winner=$(cd $wdir && fgrep -rl "lock success" . )

echo winner is $winner
echo "$fails for $runs runs"

[[ $(($fails+1)) == $runs ]]


