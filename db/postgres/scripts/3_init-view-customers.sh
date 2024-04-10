#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE OR REPLACE VIEW vw_customers as (
SELECT floor(random()* (100 + 1) + 0) as age,
row_number() over () as id,
row_number() over () %2 as group_a,
row_number() over () %10 as group_b,
'user'||row_number() over () as username, 
normal_rand,
upper(encode(gen_random_bytes(5),'hex')) as password
FROM normal_rand(1000000, 5, 3));
EOSQL