#!/bin/bash
# PostgreSQL setup script for Codacy
# Generated at: ${timestamp}

# Enable logging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting PostgreSQL setup script"

# Exit on error
set -e

# Update system packages
echo "Updating system packages"
yum update -y
yum install -y wget curl git

# Install PostgreSQL repository
echo "Installing PostgreSQL repository"
amazon-linux-extras enable postgresql${postgres_version}
yum clean metadata
yum install -y postgresql postgresql-server postgresql-devel postgresql-contrib

# Initialize PostgreSQL
echo "Initializing PostgreSQL"
postgresql-setup --initdb

# Configure PostgreSQL to allow connections from all addresses
echo "Configuring PostgreSQL"
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf
sed -i "s/#port = 5432/port = 5432/" /var/lib/pgsql/data/postgresql.conf

# Configure PostgreSQL authentication
cat > /var/lib/pgsql/data/pg_hba.conf << EOF
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             postgres                                peer
local   all             all                                     md5
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
host    all             all             0.0.0.0/0               md5
EOF

# Start PostgreSQL
echo "Starting PostgreSQL"
systemctl enable postgresql
systemctl start postgresql

# Create Codacy user and databases
echo "Creating Codacy user and databases"
su - postgres -c "psql -c \"CREATE USER codacy WITH PASSWORD '${postgres_password}';\""
su - postgres -c "psql -c \"ALTER ROLE codacy WITH CREATEDB;\""

# Create databases
for db in accounts analysis results metrics filestore jobs listener crow; do
  echo "Creating database $db"
  su - postgres -c "psql -c \"CREATE DATABASE $db WITH OWNER=codacy;\""
done

# Install SSM agent
echo "Installing and starting SSM agent"
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Install NFS client for EFS
echo "Installing NFS client"
yum install -y nfs-utils

# Create a welcome message
echo "Creating welcome message"
cat > /etc/motd << MOTD_EOF
Welcome to the PostgreSQL server for Codacy!

PostgreSQL ${postgres_version} is installed and running.
Databases created: accounts, analysis, results, metrics, filestore, jobs, listener, crow

Connection information:
- Host: localhost
- Port: 5432
- User: codacy
- Password: ${postgres_password}

For troubleshooting, check the setup logs at /var/log/user-data.log
MOTD_EOF

echo "PostgreSQL setup complete"
