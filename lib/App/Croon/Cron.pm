package App::Croon::Cron;
use strict;
use warnings;
use utf8;
use Carp;

use constant WEEKDAY_MAP => {
    sun => 0,
    mon => 1,
    tue => 2,
    wed => 3,
    thu => 4,
    fri => 5,
    sat => 6,
};

sub translate_from_obj {
    my ($obj) = @_;

    my $min     = _validate_min($obj->{min});
    my $hour    = _validate_hour($obj->{hour});
    my $day     = $obj->{day};
    my $month   = $obj->{month};
    my $w_day   = _convert_weekday($obj->{w_day});
    my $command = _escape_command($obj->{command});

    my $cron = sprintf(
        "%s %s %s %s %s %s",
        $min, $hour, $day, $month, $w_day, $command,
    );
    return $cron;
}

sub _validate_min {
    my ($min) = @_;

    return '*' unless $min;
    if ($min !~ /^[1-5]?[0-9]$/) {
        croak '[Error] Invalid minutes is specified';
    }
    return $min;
}

sub _validate_hour {
    my ($hour) = @_;

    return '*' unless $hour;
    if ($hour !~ /^(?:1?[0-9]|2[0-3])$/) {
        croak '[Error] Invalid minutes is specified';
    }
    return $hour;
}

sub _convert_weekday {
    my ($w_day) = @_;

    return '*' unless $w_day;
    return $w_day if $w_day =~ /[0-6]/;
    WEEKDAY_MAP->{lcfirst($w_day)} or croak '[Error] Invalid weekday is specified';
}

sub _escape_command {
    my ($command) = @_;

    $command =~ s/%/\\%/g;
    return $command;
}

1;
