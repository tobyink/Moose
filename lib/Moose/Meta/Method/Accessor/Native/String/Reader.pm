package Moose::Meta::Method::Accessor::Native::String::Reader;

use strict;
use warnings;

our $VERSION = '1.13';
$VERSION = eval $VERSION;
our $AUTHORITY = 'cpan:STEVAN';

use base qw(
    Moose::Meta::Method::Accessor::Native::String
    Moose::Meta::Method::Accessor::Native::Reader
);

1;
