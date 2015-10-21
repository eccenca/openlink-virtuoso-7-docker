#!/bin/bash
docker run --name $1 -p 8890:8890 -p 1111:1111 -d eccenca/virtuoso7
