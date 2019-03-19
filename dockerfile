
# Sentiance Infrastructure Engineer Test
# reference: https://hub.docker.com/r/osrm/osrm-backend/

# base file
ARG         VERSION=latest
FROM        osrm/osrm-backend:${VERSION}

# metadata
LABEL       maintainer="Kdu Bonalume"
LABEL       version="1.0"
LABEL       description="osrm-backend dockerfile loaded with Berlin dataset"
LABEL       copyright="Sentiance NV 2018"

# workdir
ARG         path="/data"
RUN         mkdir $path
RUN         cd $path
RUN         echo $path > path.cfg
# the line above is necessary otherwise the ENTRYPOINT command will not work,
# because it doesn't understand variables declared by ARG
# and also I would not leave the ENTRYPOINT command using the absolute path
# when everything else is properly using variables for better maintainance.

# commands
RUN         wget http://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf -O $path/berlin-latest.osm.pbf
RUN         osrm-extract -p /opt/car.lua $path/berlin-latest.osm.pbf
RUN         osrm-partition $path/berlin-latest.osrm
RUN         osrm-customize $path/berlin-latest.osrm

ENTRYPOINT  osrm-routed --algorithm mld $(cat path.cfg)/berlin-latest.osrm
EXPOSE      5000
