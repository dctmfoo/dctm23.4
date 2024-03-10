#!/bin/bash
if [ $DB_TYPE = "postgres" ];
then
    export PGHOST=${DB_HOST};
    export PGPORT=${DB_PORT};
    export PGUSER=${DB_ADMIN};
    export PGPASSWORD=${DB_ADMIN_PASSWORD};
    export PGDATABASE=postgres;
    while :; do
        echo Check database availablity;
        pg_isready;
        if [ "$?" -eq 0 ];
        then
            echo Database is available;
            break;
        else
            echo Database is not available: waiting 5 seconds before retry;
            sleep 5;
        fi;
    done;
    if [ ! -z "$DB_USER" ] && [ ! -z "$DB_PASSWORD" ];
    then
        psql -tXAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER';" | grep -q 1;
        if [ "$?" -ne 0 ];
        then
            psql -c "CREATE USER $DB_USER WITH LOGIN NOSUPERUSER NOCREATEDB INHERIT NOREPLICATION CONNECTION LIMIT -1 PASSWORD '$DB_PASSWORD'; GRANT $DB_USER TO $DB_ADMIN;" || { echo Failed to create a new user in the database; exit 1; }
        fi;
    fi;
    if [ ! -z "$DB_USER" ] && [ ! -z "$DB_NAME" ];
    then
        psql -tXAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME';" | grep -q 1;
        if [ "$?" -ne 0 ];
        then
            #DB does not exist - create it. OTDS will create the schema on startup.
            psql -c "CREATE DATABASE $DB_NAME WITH OWNER = '$DB_USER' ENCODING = 'UTF8' CONNECTION LIMIT = -1;" || { echo Failed to create the OTDS database; exit 1; }
        else
            #DB exists. Update the owner of all relevant objects if it appears to have changed.
            if [ -z "$USEDEFAULTSCHEMA" ];
            then
                SCHEMA_NAME="otds";
            else
                SCHEMA_NAME=`psql -tXAc "select current_schema();"`
            fi;

            psql -tXAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME' AND pg_get_userbyid(datdba)='$DB_USER';" | grep -q 1;
            if [ "$?" -ne 0 ];
            then
                psql -c "ALTER DATABASE $DB_NAME OWNER TO $DB_USER;" || { echo Failed to set database owner; exit 1; }
                psql -d $DB_NAME -c "ALTER SCHEMA $SCHEMA_NAME OWNER TO $DB_USER;" || { echo Failed to set schema owner; exit 1; }
                for table in `psql -d $DB_NAME -tXAc "SELECT tablename FROM pg_tables where schemaname='$SCHEMA_NAME';"`;
                do
                    psql -d $DB_NAME -c "ALTER TABLE ${SCHEMA_NAME}.${table} OWNER TO $DB_USER;" || { echo Failed to set table owner; exit 1; };
                done;
            fi;
        fi;
    fi;
    IFS=',' read -r -a array <<< $DB_EXTENSIONS;
    for i in "${array[@]}"
    do
        psql -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS $i;" || { echo Failed to add extension $i to the database; exit 1; }
    done;
    echo Database initialization completed;
fi;