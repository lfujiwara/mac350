#/bin/bash
docker run \
  --publish "5432:5432" \
  --detach \
  --name postgres-mac350 \
  postgres-mac350
