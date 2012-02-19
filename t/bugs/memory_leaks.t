use strict;
use warnings;

use Test::Requires {
    'Test::LeakTrace'     => '0.01',
    'Test::Memory::Cycle' => '0',
};

use Test::More;

use Moose ();
use Moose::Util qw( apply_all_roles );

{
    package MyRole;
    use Moose::Role;
    sub myname { "I'm a role" }
}

no_leaks_ok(
    sub {
        Moose::Meta::Class->create_anon_class->new_object;
    },
    'anonymous class with no roles is leak-free'
);

no_leaks_ok(
    sub {
        Moose::Meta::Role->initialize('MyRole2');
    },
    'Moose::Meta::Role->initialize is leak-free'
);

no_leaks_ok(
    sub {
        Moose::Meta::Class->create('MyClass2')->new_object;
    },
    'creating named class is leak-free'
);

no_leaks_ok(
    sub {
        Moose::Meta::Class->create( 'MyClass', roles => ['MyRole'] );
    },
    'named class with roles is leak-free'
);

no_leaks_ok(
    sub {
        Moose::Meta::Role->create( 'MyRole2', roles => ['MyRole'] );
    },
    'named role with roles is leak-free'
);

no_leaks_ok(
    sub {
        my $object = Moose::Meta::Class->create('MyClass2')->new_object;
        apply_all_roles( $object, 'MyRole' );
    },
    'applying role to an instance is leak-free'
);

no_leaks_ok(
    sub {
        Moose::Meta::Role->create_anon_role;
    },
    'anonymous role is leak-free'
);

{
    local $TODO
        = 'Until we eliminate meta objects from being closed over by the immutabilized methods, this will leak';
    no_leaks_ok(
        sub {
            my $meta = Moose::Meta::Class->create_anon_class;
            $meta->make_immutable;
        },
        'making an anon class immutable is leak-free'
    );
}

{
    my $meta3 = Moose::Meta::Class->create('MyClass3');
    memory_cycle_ok( $meta3, 'named metaclass object is cycle-free' );
    memory_cycle_ok( $meta3->new_object, 'MyClass3 object is cycle-free' );

    my $anon_class = Moose::Meta::Class->create_anon_class;
    memory_cycle_ok($anon_class, 'anon metaclass object is cycle-free' );
    memory_cycle_ok( $anon_class->new_object, 'object from anon metaclass is cycle-free' );

    $anon_class->make_immutable;
    memory_cycle_ok($anon_class, 'immutable anon metaclass object is cycle-free' );
    memory_cycle_ok( $anon_class->new_object, 'object from immutable anon metaclass is cycle-free' );

    my $anon_role = Moose::Meta::Role->create_anon_role;
    memory_cycle_ok($anon_role, 'anon role meta object is cycle-free' );
}

done_testing;
