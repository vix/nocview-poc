use strict;
use warnings;

use Manoc;

my $app = Manoc->apply_default_middlewares(Manoc->psgi_app);
$app;

