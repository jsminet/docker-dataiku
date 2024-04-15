#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE OR REPLACE VIEW vw_customers AS 
SELECT cast(floor(random() * (100 + 1)+ 0) as integer) AS age,
    row_number() OVER () AS id,
    row_number() OVER () % 2 AS group_a,
    row_number() OVER () % 10 AS group_b,
    'user' || LPAD((row_number() OVER ())::text, 7, '0') AS username,
    normal_rand,
    upper(encode(gen_random_bytes(5), 'hex')) AS password
   FROM normal_rand(1000000, 5, 3);
EOSQL