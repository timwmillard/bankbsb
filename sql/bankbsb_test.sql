CREATE EXTENSION bankbsb;

SELECT '123-456'::bsb;
SELECT '123456'::bsb;
SELECT '000-000'::bsb;
SELECT '123-456'::bsb = '123456'::bsb;
SELECT '000001'::bsb < '000002'::bsb;
SELECT '000002'::bsb > '000001'::bsb;
SELECT '000002'::bsb >= '000002'::bsb;
SELECT '000002'::bsb <= '000002'::bsb;
SELECT '000002'::bsb <> '000003'::bsb;
SELECT '9999999'::bsb;
SELECT ''::bsb;
SELECT 'abc'::bsb;
