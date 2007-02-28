use strict;
use warnings;

use Test::More tests => 3;
use Text::CSV::LibCSV;

my $data = <<'END_CSV';
one,two,three
END_CSV
my $callback = sub {
    is(shift, 'one');
    is(shift, 'two');
    is(shift, 'three');
};
csv_parse($data, $callback);

