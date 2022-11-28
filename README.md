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
