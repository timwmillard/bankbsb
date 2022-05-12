#include "postgres.h"
#include "fmtmsg.h"
#include "utils/builtins.h"

PG_MODULE_MAGIC;

#define MAX_BANK_BSB 999999

typedef uint32_t BankBSB;

// parse_bank_bsb parses a string of the BSB number and returns a valid BSB type.
// If the string is not a valid BSB number an error is returned.
//
// Valid formats:
//
//      nnn-nnn		example "123-456" will be 123-456
//
//      nnnnnn 		will convert to nnn-nnn, example "123456" will be 123-456
//
//      nnnnn 		will convert to 0nn-nnn, example "12345" will be 012-345
//
// 	Where n is an ascii digit
//
static BankBSB parse_bank_bsb(char *bsb) {
    char raw[6];
    size_t len = strlen(bsb);
    if (len == 7 && bsb[3] == '-' ) {
        raw[0] = bsb[0];
        raw[1] = bsb[1];
        raw[2] = bsb[2];
        raw[3] = bsb[4];
        raw[4] = bsb[5];
        raw[5] = bsb[6];
    } else if (len == 6) {
        raw[0] = bsb[0];
        raw[1] = bsb[1];
        raw[2] = bsb[2];
        raw[3] = bsb[3];
        raw[4] = bsb[4];
        raw[5] = bsb[5];
    } else if (len == 5) {
        raw[0] = '0';
        raw[1] = bsb[0];
        raw[2] = bsb[1];
        raw[3] = bsb[2];
        raw[4] = bsb[3];
        raw[5] = bsb[4];
    } else {
        return 0;
    }
    int num = atoi(raw);
    if (num < 1 || num > MAX_BANK_BSB) {
         return 0;
    }
    return num;
}

// bank_bsb_string return the BSB number in the format nnn-nnn,
// where n is a digit.
// Example:
// 		"123-456"
static char *bank_bsb_string(BankBSB bsb) {
    char *str = palloc(7 * sizeof(char) + 1);
    int bank = bsb / 1000;
    int branch = bsb % 1000;
    sprintf(str, "%03d-%03d", bank, branch);
    return str;
}


PG_FUNCTION_INFO_V1(bankbsb_in);
Datum
bankbsb_in(PG_FUNCTION_ARGS)
{
    char *arg = PG_GETARG_CSTRING(0);
    BankBSB bsb = parse_bank_bsb(arg);
    PG_RETURN_INT32(bsb);
}

PG_FUNCTION_INFO_V1(bankbsb_out);
Datum
bankbsb_out(PG_FUNCTION_ARGS)
{
    BankBSB arg = PG_GETARG_INT32(0);
    if (arg < 0)
        ereport(ERROR,
            (
             errcode(ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE),
             errmsg("negative values are not allowed"),
             errdetail("value %d is negative", arg),
             errhint("make it positive")
            )
        );

    char *bsb = bank_bsb_string(arg);
    PG_RETURN_CSTRING(bsb);
}
