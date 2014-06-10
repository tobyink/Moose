use strict;
use warnings;

use lib 't/lib';

use Test::More;
use Test::Fatal;

BEGIN {
    eval { require Role::Tiny; require Class::Method::Modifiers; }
        or plan skip_all => "requires Role::Tiny and Class::Method::Modifiers";
}

use ConsumesRoleTiny;

my $obj = ConsumesRoleTiny->new;

ok($obj->does("UsesRoleTiny"), '$obj->does');
ok($obj->DOES("UsesRoleTiny"), '$obj->DOES');
is($obj->some_method, 42, 'method from role works');
is($obj->another_method(1..6), 42, 'method modifier in role works');
is($obj->conflicting_method, 999, 'method conflict between role and class resolved correctly');

subtest 'required methods in roles work' => sub {
    my $e = exception {
        package ShouldDie;
        use Moose;
        with qw( UsesRoleTiny );
    };
    ok(defined($e), 'an exception was thrown');
    isa_ok(
        $e,
        'Moose::Exception::RequiredMethodsNotImplementedByClass',
        '$e',
    );
 };

done_testing;
