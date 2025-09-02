### Create an Aurora DSQL cluster

#### Prerequisites

None

#### Steps

Create Aurora cluster
  Aurora DSQL -> Create cluster ->  Singe Region

#### Verify

Install postgresql 14+
  
```
# Install the PostgreSQL official repository
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Update repository metadata
sudo dnf update -y

sudo yum install -y postgresql15
```

Get token 

```
export PGPASSWORD="$(aws dsql generate-db-connect-admin-auth-token \
  --hostname l4abulmrpttf6mzi6xtufszcua.dsql.us-east-1.on.aws)"
```

Connect to the cluster

```
psql --version # should be 14+

psql "host=l4abulmrpttf6mzi6xtufszcua.dsql.us-east-1.on.aws \
      port=5432 dbname=postgres user=admin sslmode=require"
```

Sameple output

```
[msun@control aurora-dsql-cluster]$ export PGPASSWORD="$(aws dsql generate-db-connect-admin-auth-token \
  --hostname l4abulmrpttf6mzi6xtufszcua.dsql.us-east-1.on.aws)"
[msun@control aurora-dsql-cluster]$ psql "host=l4abulmrpttf6mzi6xtufszcua.dsql.us-east-1.on.aws \
      port=5432 dbname=postgres user=admin sslmode=require"
psql (15.14, server 16.10)
WARNING: psql major version 15, server major version 16.
         Some psql features might not work.
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_128_GCM_SHA256, compression: off)
Type "help" for help.

postgres=>
```
