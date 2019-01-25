
#mkdir -p /u01/app/quest
#rm -fR /u01/app/quest/shareplex9.2/ ; rm -fR /u01/app/quest/vardir/ 
mkdir -p /u01/app/quest/shareplex9.2/ ; mkdir -p /u01/app/quest/vardir/2100/

echo "******************************************************************************"
echo "Shareplex installation." `date`
echo "******************************************************************************"
#rm -Rf /u01/app/quest/vardir/2100/
cd /vagrant_software
licence_key=`cat /vagrant_software/shareplex_licence_key.txt`
customer_name=`cat /vagrant_software/shareplex_customer_name.txt`
#SP_SYS_HOST_NAME=ol7-postgresql106-splex3
. /vagrant_config/install.env
SP_SYS_HOST_NAME=${NODE3_HOSTNAME}

#root
#echo -e "postgres\n/u01/app/quest/shareplex9.2/\n/u01/app/quest/vardir/2100/\n\n\n\n\n\n\n${licence_key}\n${customer_name}" | ./SPX-9.2.0-b42-oracle110-rh-40-amd64-m64.tpm
echo -e "/u01/app/quest/shareplex9.2/\n/u01/app/quest/vardir/2100/\n\n\n\n\n${licence_key}\n${customer_name}" | ./SPX-9.2.0-b42-oracle110-rh-40-amd64-m64.tpm

echo "******************************************************************************"
echo "PostgreSQL configuration." `date`
echo "******************************************************************************"
cd /opt/PostgreSQL/10/bin
#PGPASSWORD=postgres ./psql -c "drop database testdb;"
PGPASSWORD=postgres ./psql -c "create database testdb;"
#PGPASSWORD=postgres ./psql -d testdb -c "drop user test;"
PGPASSWORD=postgres ./psql -d testdb -c "create user test with encrypted password 'test';"
PGPASSWORD=postgres ./psql -d testdb -c "grant all privileges on database testdb to test;"
#PGPASSWORD=test ./psql -d testdb -U test -c "drop schema test;"
PGPASSWORD=test ./psql -d testdb -U test -c "create schema test;"
PGPASSWORD=test ./psql -d testdb -U test -c "create table test.test (id numeric not null, constraint pk_test primary key (id));"
PGPASSWORD=test ./psql -d testdb -U test -c "select * from test.test;"

echo "******************************************************************************"
echo "ODBC configuration." `date`
echo "******************************************************************************"
cat >> /u01/app/quest/vardir/2100/odbc/odbc.ini <<EOF

[postgres]
Driver = PostgreSQL
Server = localhost
Port = 5432
EOF

cat >> /u01/app/quest/vardir/2100/odbc/odbcinst.ini <<EOF

[PostgreSQL]
Description = PostgreSQL ODBC driver
Driver = /usr/lib/odbc/psqlodbca.so
Setup = /usr/lib/odbc/libodbcpsqlS.so
Driver64 = /usr/lib64/psqlodbcw.so
Setup64 = /usr/lib64/libodbcpsqlS.so
EOF



echo "******************************************************************************"
echo "Quest Shareplex configuration." `date`
echo "******************************************************************************"
cd /u01/app/quest/shareplex9.2/bin
echo -e "postgres\npostgres\npostgres\n\ntestdb\n\nsplex\nsplex\nsplex\n" | ./pg_setup

echo "******************************************************************************"
echo "Quest Shareplex start process." `date`
echo "******************************************************************************"
cd /u01/app/quest/shareplex9.2/bin
./sp_cop -u2100 &
sleep 5

echo "******************************************************************************"
echo "Quest Shareplex show configuration." `date`
echo "******************************************************************************"
echo -e ""
echo -e "show\nstatus" | /u01/app/quest/shareplex9.2/bin/sp_ctrl


echo -e "connection r.postgres set user=postgres" | ./sp_ctrl
echo -e "connection r.postgres set password=postgres" | ./sp_ctrl
echo -e "connection r.postgres set port=5432" | ./sp_ctrl
echo -e "connection r.postgres set server=localhost" | ./sp_ctrl
#echo -e "connection r.postgres set driver=/database/ODBC/lib/databasedriver.so" | ./sp_ctrl
echo -e "connection r.postgres set driver=/opt/PostgreSQL/10/lib/postgresql/postgres_fdw.so" | ./sp_ctrl
echo -e "connection r.postgres set driver=/usr/lib64/libodbcpsqlS.so" | ./sp_ctrl

