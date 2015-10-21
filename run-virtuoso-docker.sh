#!/bin/bash
docker run --name my-virtuoso -p 8890:8890 -p 1111:1111 -v /my/path/to/the/virtuoso/db:/var/lib/virtuoso/db -d eccenca/virtuoso7
