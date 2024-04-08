CONNECT TEST/test@//oracle-xe:1521/XEPDB1;
-- Create starter set
CREATE TABLE PEOPLE(name VARCHAR2(10));
INSERT INTO PEOPLE (name) VALUES ('Larry');
INSERT INTO PEOPLE (name) VALUES ('Bruno');
INSERT INTO PEOPLE (name) VALUES ('Gerald');
COMMIT;
exit;