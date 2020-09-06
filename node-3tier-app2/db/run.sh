#!/usr/bin/env bash
docker run --name postgres -p 5432:5432 \
  -e POSTGRES_PASSWORD=dummy \
  -e POSTGRES_USER=dummy \
  -e POSTGRES_DB=dummy \
  -d postgres:9.5

#export DB="postgres://postgres:postgres@localhost:5432/postgres"
