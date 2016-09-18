package EBiSC::MongoDB::TestFail;
use Moose;
use namespace::autoclean;
use strict;
use warnings;

has 'name' => (is => 'ro', isa => 'Str', default => 'test_fail');
with 'EBiSC::MongoDB::Role::Collection';

sub ensure_indexes {
  my ($self) = @_;
  $self->c->indexes->create_one( [date => -1]);
  $self->c->indexes->create_one( [cell_line => 1]);
  $self->c->indexes->create_one( [module => 1]);
}

__PACKAGE__->meta->make_immutable;

1;

