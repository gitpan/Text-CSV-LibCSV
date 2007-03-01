#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define NEED_newCONSTSUB
#define NEED_newRV_noinc
#define NEED_sv_2pv_nolen
#include "ppport.h"
#include "csv.h"

AV *gRow;
SV *gCallback;

static void field_callback(char *field, size_t i)
{
    if (gRow == NULL)
        gRow = newAV();
    av_push(gRow, newSVpv(field, i));
}

static void row_callback(char c)
{
    int i;
    I32 len;
    SV **field;
    len = av_len(gRow);
    dSP;
    ENTER;
    SAVETMPS;
    PUSHMARK(SP);
    for (i = 0; i <= len; i++) {
        field = av_fetch(gRow, i, 0);
        XPUSHs(*field);
    }
    PUTBACK;
    perl_call_sv(gCallback, G_DISCARD);
    FREETMPS;
    LEAVE;
    av_clear(gRow);
}

static void
init_constants()
{
    HV *stash;
    stash = gv_stashpv("Text::CSV::LibCSV", 1);
    newCONSTSUB(stash, "CSV_STRICT",    newSViv(CSV_STRICT));
    newCONSTSUB(stash, "CSV_REPALL_NL", newSViv(CSV_REPALL_NL));
}

MODULE = Text::CSV::LibCSV		PACKAGE = Text::CSV::LibCSV

PROTOTYPES: ENABLE

BOOT:
    init_constants();

void
csv_parse(sv_data, callback, opt = 0)
        SV *sv_data;
        SV *callback;
        int opt;
    PREINIT:
        struct csv_parser *parser;
        char *data;
        size_t len;
    CODE:
        gCallback = callback;
        if (csv_init(&parser, opt) != 0) {
            croak("failed to initialize csv parser");
        }
        data = SvPVX(sv_data);
        len = SvCUR(sv_data);
        if (csv_parse(parser, data, len, field_callback, row_callback) != len) {
            croak("Error: %s", csv_strerror(csv_error(parser)));
        }
        csv_fini(parser, field_callback, row_callback);
        csv_free(parser);

