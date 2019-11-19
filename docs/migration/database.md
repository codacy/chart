# Database Migration Guide

Migrating databases between pods is a straightforward process with 5 steps:
1. Dump the databases to a dump file.
2. Copy the dump file out of the old pod.
3. Copy the dump file into the new pod.
4. Apply the dump file.
5. Delete the dump file.

## Requirements

The following operations must be executed by a user which has elevated access (`SUPERUSER`) in the Postgres databases. 

All the commands will naturally have to be passed through to `kubectl` as the databases are inside a pod. Please make sure that you have it installed.

## Dumping your current data out of a running Postgres pod

You will need to know the following:
* `$POD` - the full name of the pod containing the database to migrate.
* `$DB_USER` - the username with privileged access to the database that will perform the dump.
* `$DB` - the database that you would like to export.
* `$DB_PASSWORD` - the database password.

### pg_dump
The following command lets you extract a given database into a dump file inside a pod: 
```
   kubectl exec -it $POD -- bash -c "PGPASSWORD=$DB_PASSWORD pg_dump -U $DB_USER -d $DB >> /tmp/$DB.sql"
```
This will dump the file with the `.sql` extension into the `/tmp` folder.

[For more information and additional options, please check the official documentation.](https://www.postgresql.org/docs/10/app-pgdump.html)

### pg_dumpall
If you want to dump all the dabases that are part of your Postgres, then you can use `pg_dumpall`. 
It is very similar to the `pg_dump` command provided above, with the exception that all you need to provide is `$POD`, `$DB_USER`, and `$DB_PASSWORD`
```
kubectl exec -it $POD -- bash -c "PGPASSWORD=$DB_PASSWORD pg_dumpall -U $DB_USER -c -f /tmp/$DB.sql"
```
This will dump the file with the `.sql` extension into the `/tmp` folder.

[For more information and additional options, please check the official documentation.](https://www.postgresql.org/docs/9.2/app-pg-dumpall.html)

## Moving the dumped file(s) in/out of the cluster
Once you have extracted all the SQL content that you need, you must retrieve the dump file out of the pod.
Considering all our pods live under the `codacy` namespace, and assuming that you have extracted the SQL content onto `/tmp`, you can copy this dumpfile onto your local machine with the following command:
```
kubectl cp codacy/$POD:/tmp/$DB.sql ./$DB.sql
```

## Consuming a dump file
The first step to restore your database on the new pod is to copy the dumped. You can do so with the following command:
```
kubectl cp ./$DB.dump codacy/$POD:/tmp/$DB.dump
```
Finally, we can run a `psql` command to consume the dump file and replicate the data onto Postgres:

```
kubectl exec -it $POD -- bash -c "PGPASSWORD=$DB_PASSWORD psql -U $DB_USER -f /tmp/$DB.dump"   
```

The process is identical whether you have dumped one database with `pg_dump` or all databases with `pg_dumpall`.

## Cleaning up

Do not forget to remove the dump file from the pod as it may take up unnecessary space:
```
kubectl exec -it $POD -- bash -c "rm /tmp/$DB.dump"
```

## Optimisations
The dump files contain several blank lines and comments. Should you want to remove those, you can do so with a simple `sed` command:
```
# strip empty lines and comment lines
sed -i.sql.bak '/^\s*$/d; /^--/d' ./$DB.sql
```