select * from sergio.test;
create table sergio.test (id number not null, constraint pk_test primary key (id));
insert into sergio.test values (1);
insert into sergio.test values (2);
insert into sergio.test values (3);
insert into sergio.test values (4);
insert into sergio.test values (5);
insert into sergio.test values (6);
commit;
create table test2 (id number not null, description varchar2(100), constraint pk_test2 primary key (id));
truncate table sergio.test;

