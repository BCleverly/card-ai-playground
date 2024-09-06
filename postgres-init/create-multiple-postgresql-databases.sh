#!/bin/bash

set -e
set -u

function create_database() {
	local database=$1
	echo "  Creating database '$database'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE DATABASE $database;
EOSQL
}

# Create the Label Studio database
if [ -n "$LABEL_STUDIO_POSTGRES_DB" ]; then
    create_database $LABEL_STUDIO_POSTGRES_DB
    echo "Label Studio database created"
else
    echo "LABEL_STUDIO_POSTGRES_DB is not set. Skipping Label Studio database creation."
fi

# Create the web application database
if [ -n "$WEB_POSTGRES_DB" ]; then
    create_database $WEB_POSTGRES_DB
    echo "Web application database created"
else
    echo "WEB_POSTGRES_DB is not set. Skipping web application database creation."
fi

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
		create_database $db
	done
	echo "Multiple databases created"
fi
