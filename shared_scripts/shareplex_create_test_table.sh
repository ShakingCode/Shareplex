echo "******************************************************************************"
echo "Quest Shareplex create test table." `date`
echo "******************************************************************************"
sqlplus test/test@pdb1 <<EOF

ALTER SESSION SET CONTAINER=pdb1;
CREATE TABLE TEST (id number);
INSERT INTO TEST VALUES (1);

EXIT;
EOF