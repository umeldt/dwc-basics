use strict;
use warnings;
use utf8;

use DwC;

use Test::More tests => 8;
BEGIN { use_ok('DwC::Plugin::Basics') };

my $dwc = DwC->new({
  minimumDepthInMeters => 10,
  maximumDepthInMeters => 5,
  minimumElevationInMeters => 100,
  maximumElevationInMeters => 10,
  year => 5000,
  month => 13,
  day => 32,
  kingdom => "Plantae"
});

DwC::Plugin::Basics->validate($dwc);

ok($$dwc{warning}[0][0] eq "Depth problem");
ok($$dwc{warning}[1][0] eq "Elevation problem");

like($$dwc{warning}[2][0], qr/Year out of bounds/);
like($$dwc{warning}[3][0], qr/Month out of bounds/);
like($$dwc{warning}[4][0], qr/Day out of bounds/);

is($$dwc{warning}[5], undef);

$dwc->reset();
$$dwc{kingdom} = "納豆";
DwC::Plugin::Basics->validate($dwc);
ok($$dwc{warning}[5][0], "Unknown kingdom");

