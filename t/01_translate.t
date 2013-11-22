#!perl

use strict;
use warnings;
use utf8;

use App::Croon::Cron;

use Test::More;

subtest 'normal (like a raw cron)' => sub {
    my $cron = App::Croon::Cron::translate_from_obj({
        min     => '1',
        hour    => '1',
        day     => '1',
        month   => '1',
        w_day   => '1',
        command => 'touch ~/right_$(date +%Y%m%d).txt',
    });

    is $cron, '1 1 1 1 1 touch ~/right_$(date +\%Y\%m\%d).txt';
};

done_testing;
