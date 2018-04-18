use strict;
use warnings;
use utf8;

use 5.14.0;

package DwC::Plugin::Basics;

use POSIX 'strftime';

our @kingdoms = (
  'Bacteria',
  'Archaea',
  'Protozoa',
  'Chromista',
  'Plantae',
  'Fungi',
  'Animalia'
);

sub description {
  return "Basic sanity checks";
}

sub flipped {
  my ($min, $max) = @_;
  if($min && $max) {
    $min =~ s/,/\./g; $max =~ s/,/\./g;
    return 1 if($min > $max);
  }
  return 0;
}

sub validate {
  my ($plugin, $dwc) = @_;

  if(!$$dwc{modified}) {
    $$dwc{modified} = $$dwc{dateLastModified} if $$dwc{dateLastModified};
    $$dwc{modified} = $$dwc{'dcterms:modified'} if $$dwc{'dcterms:modified'};
  }

  # validate elevation and depth
  if(flipped($$dwc{minimumDepthInMeters},$$dwc{maximumDepthInMeters})) {
    $dwc->log("warning", "Depth problem", "elevation");
  }
  if(flipped($$dwc{minimumElevationInMeters},$$dwc{maximumElevationInMeters})) {
    $dwc->log("warning", "Elevation problem", "elevation");
  }

  # ALTITUDE_OUT_OF_RANGE???

  # date validation
  my $year = strftime("%Y", gmtime);

  if($$dwc{year} && $$dwc{year} == 0) { $$dwc{year} = undef; }
  if($$dwc{month} && $$dwc{month} == 0) { $$dwc{month} = undef; }
  if($$dwc{day} && $$dwc{day} == 0) { $$dwc{day} = undef; }

  if($$dwc{year} && ($$dwc{year} > $year || $$dwc{year} < 1750)) {
    $dwc->log("warning", "Year out of bounds $$dwc{year}", "date");
  }
  if($$dwc{month} && ($$dwc{month} < 1 || $$dwc{month} > 12)) {
    $dwc->log("warning", "Month out of bounds $$dwc{month}", "date");
  }
  if($$dwc{day} && ($$dwc{day} < 1 || $$dwc{day} > 31)) {
    $dwc->log("warning", "Day out of bounds $$dwc{day}", "date");
  }

  # check kingdom (ALA: UNKNOWN_KINGDOM)
  if($$dwc{kingdom} && !grep(/^$$dwc{kingdom}$/, @kingdoms)) {
    $dwc->log("warning", "Unknown kingdom", "taxonomy");
  }
}

1;

__END__

=head1 NAME

DwC::Plugin::Basics - Basic sanity checks for DwC data

=head1 AUTHOR

umeldt

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2018 by umeldt

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.24.4 or,
at your option, any later version of Perl 5 you may have available.

=cut
