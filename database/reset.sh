#/bin/bash
./stop.sh
docker container rm postgres-mac350
./build.sh
./start.sh
