#!/bin/bash
#docker run --name $1 -p 8890:8890 -p 1111:1111 -d eccenca/virtuoso7
docker run --name $1 -p 8890:8890 -p 1111:1111 -v virtuoso.db:/var/lib/virtuoso/db/virtuoso.db -d eccenca/virtuoso7
