package ConsumesRoleTiny;

use Moose;
with qw( UsesRoleTiny );

sub another_method {
	my $self = shift;
	my $sum = 0;
	$sum += $_ for @_;
	return $sum;
}

sub required_method {
	return 1;
}

sub conflicting_method {
	return 999;
}

1;
