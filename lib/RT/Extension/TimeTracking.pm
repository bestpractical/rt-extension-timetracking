use strict;
use warnings;
package RT::Extension::TimeTracking;

our $VERSION = '0.05';

RT->AddStyleSheets("time_tracking.css");
RT->AddJavaScript("time_tracking.js");

RT::System->AddRight( Admin => AdminTimesheets  => 'Add time worked for other users' );

# RT::Date does weedkay abbreviations, but not full weekday names.
our @DAYS_OF_WEEK = (
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
);

our %WEEK_INDEX = (
    Sunday    => 0,
    Monday    => 1,
    Tuesday   => 2,
    Wednesday => 3,
    Thursday  => 4,
    Friday    => 5,
    Saturday  => 6,
);

=head1 NAME

RT-Extension-TimeTracking - Time Tracking Extension

=head1 RT VERSION

Works with RT 4.2

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item C<make initdb>

Only run this the first time you install this module.

If you run this twice, you may end up with duplicate data
in your database.

If you are upgrading this module, check for upgrading instructions
in case changes need to be made to your database.

=item patch RT

Only run this the first time you install this module.

    patch -p1 -d /path/to/rt < etc/0001-handle-txn-cfs-on-ticket-creation-and-updates-with-U.patch

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::TimeTracking');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 CONFIGURATION

=head2 C<$TimeTrackingFirstDayOfWeek>

The default week start day in MyWeek page is Monday, you can change it by
setting C<$TimeTrackingFirstDayOfWeek>, e.g.

    Set($TimeTrackingFirstDayOfWeek, 'Wednesday');

=head2 C<$TimeTrackingDisplayCF>

In the ticket listings on the My Week page, there is a room for an additional
field next to Status, Owner, etc. To display a custom field that might be
helpful when filling out your timesheet, you can set $TimeTrackingDisplayCF
to the name of that custom field. In the display, that field name will be
added to the ticket heading between Owner and Time Worked for each
day on My Week. The value will be populated for each ticket.

=head1 METHODS

=head2 WeekStartDate

Accepts an RT::User object, an RT::Date object and a day of the week (Monday,
Tuesday, etc.) and calculates the start date for the week the date object is
in using the passed day as the first day of the week. The default
first day of the week is Monday.

Returns:

($ret, $week_start, $first_day)

where $ret is true on success, false on error, $week_start is an RT::Date
object set to the calculated date, and $first_day is a string of the first
day of the week, either from $TimeTrackingFirstDayOfWeek or the default of
Monday.

=cut

sub WeekStartDate {
    my $user = shift;
    my $date = shift;
    my $first_day = shift;

    $first_day //= 'Monday';
    $first_day = ucfirst lc $first_day;

    unless ( $first_day and exists $WEEK_INDEX{$first_day} ){
        RT->Logger->warning("Invalid TimeTrackingFirstDayOfWeek value: "
             . "$first_day. It should be one of Monday, Tuesday, etc.");
        return (0, "Invalid day of week set for TimeTrackingFirstDayOfWeek");
    }

    my $day = ($date->Localtime('user'))[6];
    my $week_start = RT::Date->new($user);

    if ( $day == $WEEK_INDEX{$first_day} ){
        # Set to same day passed in
        $week_start->Set( Format => 'unix', Value => $date->Unix );
    }
    else{
        # Calculate date of first day of the week
        require Time::ParseDate;
        my $seconds = Time::ParseDate::parsedate("last $first_day",
            NOW => $date->Unix );
        $week_start->Set( Format => 'unix', Value => $seconds );
    }

    return (1, $week_start, $first_day);
}

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=head1 BUGS

Since this module is not on CPAN, bugs should be reported via
E<lt>modules@bestpractical.comE<gt>, or via standard BPS support
contract channels.

=head1 COPYRIGHT

This extension is Copyright (C) 2013-2015 Best Practical Solutions, LLC.

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
