#!/bin/bash
set -eo pipefail
shopt -s nullglob

# check to see if this file is being run or sourced from another script
_is_sourced() {
	# https://unix.stackexchange.com/a/215279
	[ "${#FUNCNAME[@]}" -ge 2 ] \
		&& [ "${FUNCNAME[0]}" = '_is_sourced' ] \
		&& [ "${FUNCNAME[1]}" = 'source' ]
}

_start() {
  if [ "$MYSQL_WAIT" = 1 ]; then
	  dockerize -wait tcp://${MYSQL_HOST:-db}:${MYSQL_PORT:-3306} -timeout 30s bash -c "$@"
  else
    bash -c "$@"
  fi
}

_main() {
	# if command starts with an option, wait for db and then start server with options
	if [ "$#" = 0 -o "${1:0:1}" = '-' ]; then
	  _start "./start_linux.sh $@"
  # same but starting with start script
  elif [ "$1" = './start_linux.sh' -o "$1" = 'start_linux.sh' -o "$1" = '/Steam/OnsetServer/start_linux.sh' ]; then
	  _start "$@"
  # otherwise, just run the user's custom command
  else
	  exec "$@"
	fi
}

# If we are sourced from elsewhere, don't perform any further actions
if ! _is_sourced; then
	_main "$@"
fi
