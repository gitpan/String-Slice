use strict;
package String::Slice;

use Exporter 'import';
our @EXPORT = qw(slice);

our $VERSION = '0.01';

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

1;

=encoding utf8

=head1 NAME

String::Slice - Shared Memory Slices of Bigger Strings

=head1 SYNOPSIS

    use String::Slice;

    my $buffer = fetch_enormous_string;
    my $slice;

    # Make $slice reference chars 101-125 of $buffer
    slice($slice, $buffer, 101, 25);

    # Make $slice reference chars 126-175 of $buffer
    slice($slice, $buffer, 25, 50);

    # Make $slice reference chars 120 to end of $buffer
    slice($slice, $buffer, -6);

    # Look for $pattern in $buffer,
    # at each 100 byte starting point
    $slice = '';    # Reset $slice
    for (my $i = 0; slice($slice, $buffer, $i); $i += 100) {
        if ($slice =~ /^$pattern/) { ... do it ... }
    }

=head1 DESCRIPTION

Processing large strings in Perl is inefficient because to access any smaller
portion of a buffer you need to make a copy of that portion.

This module lets you make a string scalar point to a portion of the content of
another string scalar.

The primary goal of this module is to make the parsing large data much faster
in Perl.

=head1 API

String::Slice exports one function: C<slice>. It can be called in a few
different ways:

    slice($slice_variable, $big_buffer_variable, $char_offset, $char_length)

This effectively makes C<$slice_variable> a substr of the buffer. The offset
defaults to 0, and if no length is given, the slice goes to the end of the
buffer. One side effect of this function is that both strings will become
readonly, and the memory will not be freed until they both go out of scope.

If C<$slice> is already a slice of C<$buffer> then this call:

    slice($slice, $buffer, $offset, $length)

will move the offset forward by the specified number (or backwards if the
offset is negative).

If length is too long, the slice will go to the end of the buffer.

The C<slice> function returns 1 on success and 0 on failure. Failure occurs if
the requested offset is invalid (less than the start or greater than or equal
to the end of the buffer).

=head1 CREDIT

Thanks go out to Jan Dubois and Florian Ragwitz for help on how to do this
right.

=head1 AUTHORS

Ingy döt Net (ingy) <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2012 Ingy döt Net

=head1 LICENSE

This library is free software and may be distributed under the same terms as
perl itself.