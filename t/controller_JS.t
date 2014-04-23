use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Manoc';
use Manoc::Controller::JS;

ok( request('/js')->is_success, 'Request should succeed' );
done_testing();
