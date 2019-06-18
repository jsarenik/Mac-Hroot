#!/bin/sh

MACJAIL=${1:-"$PWD/mac-jail"}

{
cat <<EOF
/bin/bash
/bin/cat
/bin/ls
/bin/mkdir
/bin/mv
/bin/rm
/bin/rmdir
/bin/sh
/bin/sleep
/sbin/ping
/usr/bin/curl
/usr/bin/dig
/usr/bin/env
/usr/bin/grep
/usr/bin/host
/usr/bin/id
/usr/bin/less
/usr/bin/ssh
/usr/bin/ssh-add
/usr/bin/uname
/usr/bin/vi
/usr/lib/dyld
/usr/sbin/netstat
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
