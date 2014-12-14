# Description
- Generate github wiki page for database tables
- Support PostgreSQL and Redshift

# How to use
- Copy env.sample to .env and change DATABASE_URL
- Run like this
```
thor db:tables > tmp/result.md
```

# Multiple databases
- Copy env.sample to .env.dbname and change DATABASE_URL
- Run like this
```
RAKE_ENV=dbname thor db:tables dbname > tmp/dbname.md
```

