COMMAND=$1

docker run --rm -it \
-v $(pwd)/ocp/templates:/templates:ro \
-v $(pwd)/ocp/profiles.yml:/profiles.yml:ro \
-v $(pwd)/ocp/outputs:/outputs \
us.gcr.io/dataplatform-1363/acm-dp-ocp-template-renderer:latest \
$COMMAND