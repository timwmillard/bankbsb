-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION bankbsb" to load this file. \quit

CREATE FUNCTION bankbsb_in(cstring)
RETURNS bsb
AS '$libdir/bankbsb'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bankbsb_out(bsb)
RETURNS cstring
AS '$libdir/bankbsb'
LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE bsb (
  INPUT          = bankbsb_in,
  OUTPUT         = bankbsb_out,
  LIKE           = integer,
  INTERNALLENGTH = 4,     -- use 4 bytes to store data
  ALIGNMENT      = int4,  -- align to 4 bytes
  STORAGE        = PLAIN, -- always store data inline uncompressed (not toasted)
  PASSEDBYVALUE           -- pass data by value rather than by reference
);
