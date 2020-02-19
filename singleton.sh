#!/bin/bash

lock_aquire() {
    local prefix=$1
    local fd=${2:-$SINGLETON_LOCK_FD}

    # create lock file
    eval "exec $fd>$SINGLETON_LOCK_FILE.lock"

    # acquire the lock
    flock -n $fd \
        && trap lock_release EXIT INT TERM \
        && echo $$>$SINGLETON_LOCK_FILE.pid \
        && return 0 \
        || return 1

}

lock_fail() {
    local error_str="$@"

    echo $error_str
    if [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
       exit 1
    fi
}

lock_try() {
    export SINGLETON_LOCK_NAME=$1
    export SINGLETON_LOCKFILE_DIR=/tmp
    export SINGLETON_LOCK_FD=200

    export SINGLETON_LOCK_FILE=$SINGLETON_LOCKFILE_DIR/$(echo "${SINGLETON_LOCK_NAME}_locked"  | md5sum | cut -d" " -f1)

    lock_aquire $SINGLETON_LOCK_NAME \
        || lock_fail "Another process (pid $(cat $SINGLETON_LOCK_FILE.pid)) has a lock on $SINGLETON_LOCK_NAME, aborting."
}

lock_release() {
    rm -f $SINGLETON_LOCK_FILE.lock $SINGLETON_LOCK_FILE.pid 
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    # here if script is run as a script, as opposed to being soruced
    if [ "$1" == "source" ]; then
        echo source $0
    else
        set -eu 

        lock_try $1
        shift 
        "$@"
    fi
fi 
