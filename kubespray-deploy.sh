#!/bin/sh

set -eu

TARGET=$1
KEY="-i keys/kubepgs_id_ed25519"
scp $KEY kubespray-install.sh root@$TARGET:
scp $KEY keys/kubepgs_id_ed25519 root@$TARGET:
ssh $KEY root@$TARGET -- bash ./kubespray-install.sh $TARGET