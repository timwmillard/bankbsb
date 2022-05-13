-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION bankbsb" to load this file. \quit

CREATE TYPE bsb;

CREATE FUNCTION bankbsb_in(cstring)
RETURNS bsb
AS '$libdir/bankbsb'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bankbsb_out(bsb)
RETURNS cstring
AS '$libdir/bankbsb'
LANGUAGE C IMMUTABLE STRICT;


CREATE FUNCTION bankbsb_lt(bsb, bsb)
RETURNS boolean
AS '$libdir/bankbsb'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bankbsb_le(bsb, bsb)
RETURNS boolean
AS '$libdir/bankbsb'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bankbsb_eq(bsb, bsb)
RETURNS boolean
AS '$libdir/bankbsb'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bankbsb_ne(bsb, bsb)
RETURNS boolean
AS '$libdir/bankbsb'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bankbsb_gt(bsb, bsb)
RETURNS boolean
AS '$libdir/bankbsb'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bankbsb_ge(bsb, bsb)
RETURNS boolean
AS '$libdir/bankbsb'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bankbsb_cmp(bsb, bsb)
RETURNS integer
AS '$libdir/bankbsb'
LANGUAGE C IMMUTABLE STRICT;


CREATE TYPE bsb (
  input          = bankbsb_in,
  output         = bankbsb_out,
  internallength = 4,
  alignment      = int4,
  storage        = plain,
  passedbyvalue
);

CREATE OPERATOR < (
    leftarg = bsb,
    rightarg = bsb,
    commutator = >,
    negator = >=,
    restrict = scalarltsel,
    join = scalarltjoinsel,
    function = bankbsb_lt
);

CREATE OPERATOR <= (
    leftarg = bsb,
    rightarg = bsb,
    commutator = >=,
    negator = >,
    restrict = scalarlesel,
    join = scalarlejoinsel,
    function = bankbsb_le
);

CREATE OPERATOR = (
    leftarg = bsb,
    rightarg = bsb,
    commutator = =,
    negator = <>,
    restrict = eqsel,
    join = eqjoinsel,
    hashes,
    merges,
    function = bankbsb_eq
);

CREATE OPERATOR <> (
    leftarg = bsb,
    rightarg = bsb,
    commutator = <>,
    negator = =,
    restrict = neqsel,
    join = neqjoinsel,
    function = bankbsb_ne
);

CREATE OPERATOR >= (
    leftarg = bsb,
    rightarg = bsb,
    commutator = <=,
    negator = <,
    restrict = scalargesel,
    join = scalargejoinsel,
    function = bankbsb_ge
);

CREATE OPERATOR > (
    leftarg = bsb,
    rightarg = bsb,
    commutator = <,
    negator = <=,
    restrict = scalargtsel,
    join = scalargtjoinsel,
    function = bankbsb_gt
);

CREATE OPERATOR CLASS bankbsb_ops
    DEFAULT FOR TYPE bsb USING btree AS
        OPERATOR        1       < ,
        OPERATOR        2       <= ,
        OPERATOR        3       = ,
        OPERATOR        4       >= ,
        OPERATOR        5       > ,
        FUNCTION        1       bankbsb_cmp(bsb, bsb);


CREATE SCHEMA IF NOT EXISTS ausbank;

CREATE TABLE ausbank.institution (
    id serial PRIMARY KEY,
    code varchar(3) NOT NULL,
    name text NOT NULL,
    bsb_numbers varchar(3)[]
);

CREATE TABLE ausbank.branch (
    id serial PRIMARY KEY,
    code bsb NOT NULL,
    name text NOT NULL DEFAULT '',
    institution_code varchar(3) NOT NULL DEFAULT '',
    insitiution_id int REFERENCES ausbank.institution(id)
    address text NOT NULL DEFAULT '',
    suburb text NOT NULL DEFAULT '',
    state text NOT NULL DEFAULT '',
    postcode varchar(4) NOT NULL DEFAULT ''
);

CREATE OR REPLACE FUNCTION bsblookup(b bsb) RETURNS text
AS
$$
    SELECT name
    FROM ausbank.branch
    WHERE code = b;

    RETURN 1;
$$
LANGUAGE 'plpgsql';
