#!/bin/sh

MACJAIL=${1:-"$PWD/mac-jail"}

{
cat <<EOF
/usr/lib/dyld
/bin/bash
/bin/ls
/bin/cat
/bin/rm
/bin/mkdir
/bin/rmdir
/bin/mv
/bin/sleep
/sbin/ping
/usr/bin/vi
/usr/bin/grep
/usr/bin/less
/usr/bin/env
/usr/bin/host
/usr/bin/dig
/usr/bin/curl
/usr/bin/ssh
/usr/sbin/netstat
/usr/local/bin/mksh
EOF
} | while read bin
do
  ./prepare-mac-chroot.sh "$MACJAIL" "$bin"
done

{
cat <<EOF
/dev/null
/dev/console
/dev/tty
/usr/share/terminfo
$HOME/.ssh
EOF
} | while read file
do
  file=`echo $file`
  TO=$MACJAIL/${file#/}
  eval test -e "$TO" && continue
  mkdir -p ${TO%/*}
  eval sudo cp -avR "$file" "$TO"
done
sudo chown -R $USER $MACJAIL
