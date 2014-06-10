package UsesRoleTiny;

use Role::Tiny;

requires 'required_method';

sub some_method {
	return 42;
}

around another_method => sub {
	my $next = shift;
	my $self = shift;
	
	return 2 * $self->$next(@_);
};

sub conflicting_method {
	return 666;
}

1;
