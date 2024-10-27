#!/bin/bash

set -e

if [ "$1" = 'server' ]; then
  shift
  # Figure out public address
  export GHIDRA_PUBLIC_HOSTNAME=${GHIDRA_PUBLIC_HOSTNAME:-$(dig +short myip.opendns.com @resolver1.opendns.com)}

  # Add users
  GHIDRA_ADMINS=${GHIDRA_ADMINS:-admin}
  GHIDRA_USERS=${GHIDRA_USERS:-admin}
  if [ ! -e "/repos/users" ] && [ ! -z "${GHIDRA_ADMINS}" ]; then
    mkdir -p /repos/~admin
    for user in ${GHIDRA_ADMINS}; do
      echo "Adding admin: ${user}"
      echo "-add ${user}" >> /repos/~admin/adm.cmd
    done
      # Add non-admin users
    for user in ${GHIDRA_USERS}; do
      echo "Adding non-admin user: ${user}"
      echo "-add ${user}" >> /repos/~admin/adm.cmd
    done
  fi

  exec "/ghidra/server/ghidraSvr" console
fi

exec "$@"
