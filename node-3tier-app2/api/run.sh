#!/usr/bin/env bash

#export PGUSER=postgres
#export PGHOST=127.0.0.1
#export PGPASSWORD=postgres
#export PGDATABASE=postgres
#export PGPORT=4321

  #DB=postgres://postgres:postgres@127.0.0.1:5432/postgres  \
NODE_ENV=development \
  DB=postgres://dummy:dummy@localhost:5432/dummy  \
  npm start

