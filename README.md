# `bsb` type for PostgreSQL

A PostgreSQL Extension to add an Australian banking BSB number type.

## Install

To build and install this module:

```sh
make
make install
```

or selecting a specific PostgreSQL installation:

```sh
make PG_CONFIG=/some/where/bin/pg_config
make PG_CONFIG=/some/where/bin/pg_config install
```

And finally create the extension inside the database:

```sql
CREATE EXTENSION bankbsb;
```

## Usage

This module provides a data type `bsb` that you can use like a normal type. For example:

```sql
CREATE TABLE account (
    id int PRIMARY KEY,
    branch_code bsb
);

INSERT INTO account VALUES (1, '123-456');
```

Valid BSB formats:
- `nnn-nnn`		example `123-456` will be `123-456`
- `nnnnnn` 		will convert to `nnn-nnn`, example `123456` will be `123-456`
- `nnnnn` 		will convert to `0nn-nnn`, example `12345` will be `012-345`

Where n is an ASCII digit

---

## Testing

Install the extension

```sh
make
make install
```

Run the regression test
```sh
make installcheck
```

If the test fails, the result output will be in `results/bankbsb_test.out`.  You can then diff this with `expected/bankbsb_test.out`.


## Docker

Try the extension using Docker.  Pick a local port you want Postgres to run on.  Port 5432 may already be taken via another Postgres instance, so pick a different port it needed.

```sh
docker build -t postgres-bankbsb .
export PORT=5433
export POSTGRES_PASSWORD=mypassword
docker run -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} -p ${PORT}:5432 -d postgres-bankbsb
psql -h localhost -p ${PORT} -U postgres
```

Enter password at the prompt.  Then enable the extension.

```sql
CREATE EXTENSION bankbsb; 
```

Use the `bsb` type as you need.

```sql
CREATE TABLE account (
    id serial PRIMARY KEY,
    branch_code bsb
);

INSERT INTO account (branch_code) VALUES ('123456');
SELECT * FROM account;
```

```
 id | branch_code
----+-------------
  1 | 123-456
(1 row)
```