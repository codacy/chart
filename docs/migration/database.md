# Database Migration Guide

Migrating databases between pods is a straightforward process with 3 steps:
1. Dump the databases to a dump file.
2. Apply the dump file.
3. Delete the dump file.

You will have to dump all the following databases:
1. accounts 
2. analysis
3. filestore
4. jobs
5. metrics
6. results
7. results201709

## Requirements

The following operations must be executed by a user which has elevated access (`SUPERUSER`) in the Postgres databases. 

## Dumping your current data out of a running Postgres

You will need to know the following:
* `$HOSTNAME` - the hostname where the database is located.
* `$DB_USER` - the username with privileged access to the database that will perform the dump.
* `$DB` - the database that you would like to export.
* `$DB_PASSWORD` - the database password.

### pg_dump
The following command lets you extract a given database into a dump file: 
```
   $> PGPASSWORD=$DB_PASSWORD pg_dump -h $HOSTNAME -U $DB_USER -d $DB -F t -f /tmp/$DB.sql.tar"
```
This will dump the file with the `.sql.tar` extension into the `/tmp` folder.

[For more information and additional options, please check the official documentation.](https://www.postgresql.org/docs/10/app-pgdump.html)

## pg_restore
To restore a database, you can run a `pg_restore` command to consume the dump file and replicate the data onto Postgres:

```
   $> PGPASSWORD=$DB_PASSWORD pg_restore -h $HOSTNAME -U $DB_USER -d $DB -F t /tmp/$DB.sql.tar
```

[For more information and additional options, please check the official documentation.](https://www.postgresql.org/docs/9.6/app-pgrestore.html)