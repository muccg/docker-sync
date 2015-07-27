#!/bin/bash


function defaults {
    : ${SYNC_SOURCE="."}
    : ${SYNC_DEST="."}

    if [ "${SYNC_SOURCE}" = "${SYNC_DEST}" ]; then
        echo "SYNC_SOURCE same as SYNC_DEST"
        exit 1
    fi

    : ${SYNC_OPTS=""}
}


function ec2_defaults {
    : ${AWS_DEFAULT_REGION:="ap-southeast-2"}
 
    if [[ -z "$AWS_ACCESS_KEY_ID" ]] ; then
        echo "AWS_ACCESS_KEY_ID not set"
        exit 1
    fi

    if [[ -z "$AWS_SECRET_ACCESS_KEY" ]] ; then
        echo "AWS_SECRET_ACCESS_KEY not set"
        exit 1
    fi

}


echo "HOME is ${HOME}"
echo "WHOAMI is `whoami`"

defaults

# s3 entrypoint
if [ "$1" = 's3' ]; then
    echo "[Run] Starting s3 sync"

    ec2_defaults

    set -o pipefail
    set -x
    aws s3 sync ${SYNC_OPTS} ${SYNC_SOURCE} ${SYNC_DEST} 2>&1 | tee /data/sync.log
    aws s3 sync ${SYNC_OPTS} sync.log ${SYNC_DEST}
    exit $?
fi

echo "[RUN]: Builtin command not provided [s3]"
echo "[RUN]: $@"

exec "$@"
