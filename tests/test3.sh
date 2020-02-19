#!/bin/bash

# this test tries to force unlock the lock from another process

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

            # here we lock release despite failure, this should NOT UNLOCK
            lock_release

        fi
    )  > $wdir/$i.out 2>&1 &
done

wait 

for f in $(ls $wdir/*.out ) ; do
    echo $f
    cat $f
    echo ""
done

fails=$(cat $wdir/*.out | grep "lock fail" | wc -l)
winner=$(cd $wdir && fgrep -rl "lock success" . )

echo winner is $winner
echo "$fails for $runs runs"



[[ $(($fails+1)) == $runs ]]
