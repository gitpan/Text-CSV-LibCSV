package Text::CSV::LibCSV;
use strict;
use warnings;
use vars qw($VERSION @ISA @EXPORT);

BEGIN {
    $VERSION = '0.01';
    if ($] > 5.006) {
        require XSLoader;
        XSLoader::load(__PACKAGE__, $VERSION);
    } else {
        require DynaLoader;
        @ISA = qw(DynaLoader);
        __PACKAGE__->bootstrap;
    }
    require Exporter;
    push @ISA, 'Exporter';
    @EXPORT = qw(csv_parse CSV_STRICT CSV_REPALL_NL);
}

1;
__END__

=head1 NAME

Text::CSV::LibCSV - comma-separated values manipulation routines (using libcsv)

=head1 SYNOPSIS

  use Text::CSV::LibCSV;

  my $callback = sub {
       my @fields = @_;
       print(join(',', @fields), "\n");
  };
  csv_parse($data, $callback);

=head1 DESCRIPTION

This module is an interface for libcsv.
It is available at: http://sourceforge.net/projects/libcsv/

=head1 METHODS

=over 4

=item csv_parse($data, $callback [, $option])

Parse a CSV string.

Callback function is called at the end of every row.

Option can be set CSV_STRICT or CSV_REPALL_NL.
Read libcsv's documentation for details.

=back

=head1 EXPORT

csv_parse, CSV_STRICT, CSV_REPALL_NL

=head1 AUTHOR

Jiro Nishiguchi E<lt>jiro@cpan.orgE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<http://sourceforge.net/projects/libcsv/>

=cut

