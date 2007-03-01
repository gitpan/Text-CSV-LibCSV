use strict;
use warnings;

use Test::More tests => 7;
use Text::CSV::LibCSV;

my $data = <<'END_CSV';
one,two,three
END_CSV
my $callback = sub {
    is(scalar @_, 3);
    is(shift, 'one');
    is(shift, 'two');
    is(shift, 'three');
};
csv_parse($data, $callback);

# data contains a NUL character
$data = <<"END_CSV";
ab\0,c
END_CSV
$callback = sub {
    is(scalar @_, 2);
    is(shift, "ab\0");
    is(shift, "c");
};
csv_parse($data, $callback);
