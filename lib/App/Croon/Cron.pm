package App::Croon::Cron;
use strict;
use warnings;
use utf8;

sub translate_from_obj {
    my ($obj) = @_;

    my $min     = $obj->{min};
    my $hour    = $obj->{hour};
    my $day     = $obj->{day};
    my $month   = $obj->{month};
    my $w_day   = $obj->{w_day};
    my $command = _escape_command($obj->{command});

    my $cron = sprintf(
        "%d %d %d %d %d %s",
        $min, $hour, $day, $month, $w_day, $command,
    );
    return $cron;
}

sub _escape_command {
    my ($command) = @_;

    $command =~ s/%/\\%/g;
    return $command;
}

1;
