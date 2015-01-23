#!/bin/sh

MACJAIL=${1:-"$PWD/mac-jail"}
MYBIN=${2:-"/bin/bash"}

mycopy() {
  FROM=$1
  BN=${FROM##*/}
  DN=${FROM%/*}
  TO=$MACJAIL/$DN
  test -r $TO/$BN && return 0
  echo $FROM
  mkdir -p "${TO}"
  cp "$FROM" "$TO"
  otool -L "$TO/$BN" | sed 1d | awk '{print $1}' | while read lib
  do
    mycopy "$lib"
  done
}

test -d $MACJAIL || mkdir $MACJAIL
mycopy $MYBIN
