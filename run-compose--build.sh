#!/usr/bin/env bash
set -e
#source common.sh

[[ $(basename $0) =~ run-compose--(.*).sh ]]
COMPOSE_PROFILE=${BASH_REMATCH[1]}

COMMAND=$1
COMPOSE_PROJECT=$(basename `pwd` | sed 's/-/_/g')_${COMPOSE_PROFILE}
docker-compose -p $COMPOSE_PROJECT -f compose/docker-compose.yml -f compose/docker-compose.${COMPOSE_PROFILE}.yml $COMMAND
