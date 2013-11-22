#!perl

use strict;
use warnings;
use utf8;

use App::Croon::Cron;

use Test::More;

subtest 'normal (like a raw cron)' => sub {
    my $cron = App::Croon::Cron::translate_from_obj({
        min     => 1,
        hour    => 1,
        day     => 1,
        month   => 1,
        w_day   => 1,
        command => 'touch ~/right_$(date +%Y%m%d).txt',
    });

    is $cron, '1 1 1 1 1 touch ~/right_$(date +\%Y\%m\%d).txt';
};

subtest 'weekday' => sub {
    my $cron;

    $cron = App::Croon::Cron::translate_from_obj({
        min     => 1,
        hour    => 1,
        day     => 1,
        month   => 1,
        w_day   => 'Mon',
        command => 'echo "hello"',
    });
    is $cron, '1 1 1 1 1 echo "hello"', 'First character is upper case';

    $cron = App::Croon::Cron::translate_from_obj({
        min     => 1,
        hour    => 1,
        day     => 1,
        month   => 1,
        w_day   => 'mon',
        command => 'echo "hello"',
    });
    is $cron, '1 1 1 1 1 echo "hello"', 'All characters are lower case';

    eval {
        $cron = App::Croon::Cron::translate_from_obj({
            min     => 1,
            hour    => 1,
            day     => 1,
            month   => 1,
            w_day   => 7,
            command => 'echo "hello"',
        });
    };
    ok $@, 'Invalid weekday is specified as number';

    eval {
        $cron = App::Croon::Cron::translate_from_obj({
            min     => 1,
            hour    => 1,
            day     => 1,
            month   => 1,
            w_day   => 'Invalid',
            command => 'echo "hello"',
        });
    };
    ok $@, 'Invalid weekday is specified as string';

    eval {
        $cron = App::Croon::Cron::translate_from_obj({
            min     => 1,
            hour    => 1,
            day     => 1,
            month   => 1,
            command => 'echo "hello"',
        });
    };
    is $cron, '1 1 1 1 * echo "hello"', 'Not specified weekday';
};

subtest 'min' => sub {
    my $cron;

    eval {
        $cron = App::Croon::Cron::translate_from_obj({
            min     => 60,
            hour    => 1,
            day     => 1,
            month   => 1,
            w_day   => 1,
            command => 'echo "hello"',
        });
    };
    ok $@, 'Over 60 min';

    eval {
        $cron = App::Croon::Cron::translate_from_obj({
            hour    => 1,
            day     => 1,
            month   => 1,
            w_day   => 1,
            command => 'echo "hello"',
        });
    };
    is $cron, '* 1 1 1 1 echo "hello"', 'Not specified min';
};

subtest 'hour' => sub {
    my $cron;

    eval {
        $cron = App::Croon::Cron::translate_from_obj({
            min     => 1,
            hour    => 24,
            day     => 1,
            month   => 1,
            w_day   => 1,
            command => 'echo "hello"',
        });
    };
    ok $@, 'Over 24 hours';

    eval {
        $cron = App::Croon::Cron::translate_from_obj({
            min     => 1,
            day     => 1,
            month   => 1,
            w_day   => 1,
            command => 'echo "hello"',
        });
    };
    is $cron, '1 * 1 1 1 echo "hello"', 'Not specified hour';
};

done_testing;
