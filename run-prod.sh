COMMAND=$1
COMPOSE_PROJECT=$(basename `pwd` | sed 's/-/_/g')_prod
docker-compose -p $COMPOSE_PROJECT -f compose/docker-compose.yml -f compose/docker-compose.prod.yml $COMMAND