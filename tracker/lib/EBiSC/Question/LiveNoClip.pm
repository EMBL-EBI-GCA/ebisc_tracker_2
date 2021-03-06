package EBiSC::Question::LiveNoClip;
use Moose;
use namespace::autoclean;
use boolean qw(true false);
use strict;
use warnings;

our $title = 'Do all "go live" cell lines have a CLIP in IMS?';
our $description = <<EOF;

A cell line is tested if...

* If line is exported by the IMS API
* ...and if that line is marked as "go live"
* ...and if that line is not marked as availability="Restricted distribution"

Requirements to pass:

* The cell line has a cell_line_information_pack listed in the IMS

EOF


sub run {
  my ($self) = @_;

  my $cursor = $self->db->ims_line->c->find(
    {
      'obj.flag_go_live' => boolean::true,
      'obj.cell_line_information_packs.0' => {'$exists' => boolean::false},
      'obj.availability' => {'$ne' => 'Restricted distribution'},
    },
    {projection => {name => 1}},
  );
  foreach my $fail ($cursor->all) {
    $self->add_failed_line(cell_line => $fail->{name});
  }
  my $num_tested = $self->db->ims_line->c->count(
    {
      'obj.flag_go_live' => boolean::true,
      'obj.availability' => {'$ne' => 'Restricted distribution'},
    }
  );
  $self->num_tested($num_tested);

}

with 'EBiSC::Question::Role::Question';

1;
