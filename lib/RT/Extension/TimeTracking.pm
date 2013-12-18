use strict;
use warnings;
package RT::Extension::TimeTracking;

our $VERSION = '0.01';

RT->AddStyleSheets("time_tracking.css");
RT->AddJavaScript("time_tracking.js");

RT::System->AddRight( Admin => AdminTimesheets  => 'Add time worked for other users' );

=head1 NAME

RT-Extension-TimeTracking - Time Tracking Extension

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

    patch -p1 -d /path/to/rt < etc/0001-handle-txn-cfs-on-ticket-creation-and-updates-with-U.patch

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Set(@Plugins, qw(RT::Extension::TimeTracking));

or add C<RT::Extension::TimeTracking> to your existing C<@Plugins> line.

The default week start day in MyWeek page is Monday, you can change it by
setting C<$TimeTrackingFirstDayOfWeek>, e.g.

    Set($TimeTrackingFirstDayOfWeek, 'Wednesday');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 AUTHOR

sunnavy <sunnavy@bestpractical.com>

=head1 BUGS

All bugs should be reported via email to
L<bug-RT-Extension-TimeTracking@rt.cpan.org|mailto:bug-RT-Extension-TimeTracking@rt.cpan.org>
or via the web at
L<rt.cpan.org|http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-TimeTracking>.


=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013, Best Practical Solutions, LLC.

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
