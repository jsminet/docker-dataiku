CONNECT TEST/test@//oracle-xe:1521/XEPDB1;
-- Create starter set
CREATE OR REPLACE VIEW CUSTOMERS_VW as (
    SELECT rownum as UNIQUE_ID,
    'user'||rownum as USR_NAME,
    'group'||mod(rownum,2) as GROUP_A,
    'group'||mod(rownum,10) as GROUP_B,
    to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') as LONG_ID,
    rpad('*',30,'*') as CHAR_PAD,
    DBMS_RANDOM.RANDOM as RANDOM,
    DBMS_RANDOM.STRING('U',10) as SIMPLE_PASSWORD,
    DBMS_RANDOM.STRING('P',10) as PASSWORD,
    trunc(DBMS_RANDOM.VALUE(0,100)) as AGE
    FROM dual CONNECT BY level <= 1000000
);
COMMIT;
exit;