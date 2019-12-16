# Database Migration Guide

Migrating databases between pods is a straightforward process with 3 steps:

1.  Dump the databases to a dump file.
2.  Apply the dump file.
3.  Delete the dump file.

You will have to dump all the following databases:

1.  accounts
2.  analysis
3.  filestore
4.  jobs
5.  metrics
6.  results
7.  results201709

## Requirements

The following operations must be executed by a user which has elevated access (`SUPERUSER`) in the Postgres databases.

## Dumping your current data out of a running Postgres

You will need to know the following:

-   `$HOSTNAME` - the hostname where the database is located.
-   `$DB_USER` - the username with privileged access to the database that will perform the dump.
-   `$DB` - the database that you would like to export.
-   `$DB_PASSWORD` - the database password.

### pg_dump

The following command lets you extract a given database into a dump file:

```bash
PGPASSWORD=$DB_PASSWORD pg_dump -h $HOSTNAME -U $DB_USER -d $DB -F t -f /tmp/$DB.sql.tar"
```

This will dump the file with the `.sql.tar` extension into the `/tmp` folder.

[For more information and additional options, please check the official documentation.](https://www.postgresql.org/docs/10/app-pgdump.html)

### pg_restore

To restore a database, you can run a `pg_restore` command to consume the dump file and replicate the data onto Postgres:

```bash
PGPASSWORD=$DB_PASSWORD pg_restore -h $HOSTNAME -U $DB_USER -d $DB -F t /tmp/$DB.sql.tar
```

[For more information and additional options, please check the official documentation.](https://www.postgresql.org/docs/9.6/app-pgrestore.html)

## Sample script

Assuming you have the same `$DB_USER` and `$DB_PASSWORD`, and that you want to migrate all the databases from the same hostname to the same destination hostname, you could easily migrate your databases with the following sample script:

```bash
SRC_HOSTNAME=$1
DEST_HOSTNAME=$2
DB_USER=$3
DB_PASSWORD=$4

declare -a dbs=(accounts analysis filestore jobs metrics results results201709)
for db in ${dbs[@]}
do
  PGPASSWORD=$DB_PASSWORD pg_dump -h $SRC_HOSTNAME -U $DB_USER -d $DB -F t -f /tmp/$DB.sql.tar"
  PGPASSWORD=$DB_PASSWORD pg_restore -h $DEST_HOSTNAME -U $DB_USER -d $DB -F t /tmp/$DB.sql.tar
done
```

You could simply invoke it with:

```bash
migrateDBs.sh postgres–instance1.us-east-1.rds.amazonaws.com postgres–instance1.eu-west-1.rds.amazonaws.com super_user secret_password
```
