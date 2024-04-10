#!/bin/bash
set -e
# tablefunc istallation - https://www.postgresql.org/docs/current/tablefunc.html
# pgcrypto istallation - https://www.postgresql.org/docs/current/pgcrypto.html

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE EXTENSION IF NOT EXISTS "tablefunc";
	CREATE EXTENSION IF NOT EXISTS "pgcrypto";
EOSQL