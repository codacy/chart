# Use external databases

Even though we deliver a Postgres instance as part of the Kubernetes cluster so that you can start Codacy really fast, this configuration is really not recommended for a production ready installation.

Assuming you already have an external Postgres instance available, follow the steps below to configure Codacy to use the instance:

1. Create a user to be used by Codacy in your Postgres:

    ```sql
      CREATE USER codacy WITH PASSWORD 'codacy';
      ALTER ROLE codacy WITH CREATEDB;
    ```

1. Create the different databases needed for the different services in Postgres:

    ```sql
      CREATE DATABASE accounts WITH OWNER=codacy;
      CREATE DATABASE analysis WITH OWNER=codacy;
      CREATE DATABASE results WITH OWNER=codacy;
      CREATE DATABASE metrics WITH OWNER=codacy;
      CREATE DATABASE filestore WITH OWNER=codacy;
      CREATE DATABASE jobs WITH OWNER=codacy;
      CREATE DATABASE activities WITH OWNER=codacy;
      CREATE DATABASE hotsposts WITH OWNER=codacy;
      CREATE DATABASE listener WITH OWNER=codacy;
    ```

1. Create a `database-values.yaml` file that disables the creation of the DBs inside the cluster and configure the correct external `hostname`, `username`, `password` and `databaseName`.

    ```yaml
    global:
      defaultdb:
        create: false
        postgresqlUsername: codacy
        postgresqlDatabase: accounts # You need to create the DB manually
        postgresqlPassword: codacy
        host: codacy-database.internal
        service:
          port: 5432
      analysisdb:
        create: false
        postgresqlUsername: codacy
        postgresqlDatabase: analysis # You need to create the DB manually
        postgresqlPassword: codacy
        host: codacy-database.internal
        service:
          port: 5432
      resultsdb:
        create: false
        postgresqlUsername: codacy
        postgresqlDatabase: results # You need to create the DB manually
        postgresqlPassword: codacy
        host: codacy-database.internal
        service:
          port: 5432
      metricsdb:
        create: false
        postgresqlUsername: codacy
        postgresqlDatabase: metrics # You need to create the DB manually
        postgresqlPassword: codacy
        host: codacy-database.internal
        service:
          port: 5432
      filestoredb:
        create: false
        postgresqlUsername: codacy
        postgresqlDatabase: filestore # You need to create the DB manually
        postgresqlPassword: codacy
        host: codacy-database.internal
        service:
          port: 5432
      jobsdb:
        create: false
        postgresqlUsername: codacy
        postgresqlDatabase: jobs # You need to create the DB manually
        postgresqlPassword: codacy
        host: codacy-database.internal
        service:
          port: 5432

    activities:
      activitiesdb:
        create: false
        postgresqlUsername: codacy
        postgresqlDatabase: activities # You need to create the DB manually
        postgresqlPassword: codacy
        host: codacy-database.internal
        service:
          port: 5432

    hotspots-api:
      hotspotsdb:
        create: false
        postgresqlUsername: codacy
        postgresqlDatabase: hotsposts # You need to create the DB manually
        postgresqlPassword: codacy
        host: codacy-database.internal
        service:
          port: 5432

    listener:
      listenerdb:
        create: false
        postgresqlUsername: codacy
        postgresqlDatabase: listener # You need to create the DB manually
        postgresqlPassword: codacy
        host: codacy-database.internal
        service:
          port: 5432
    ```
