#!/bin/sh

echo "$@"

command=$1
shift

if ! [[ " list delete undelete " == *$command* ]]; then
  for arg do
    shift
    case $arg in
      (--newer*) : ;;
      (--older*) : ;;
      (--includes*) : ;;
      (--excludes*) : ;;
         (*) set -- "$@" "$arg" ;;
    esac
  done
fi

/bin/usc $command "$@"
