package smokebrew;
$smokebrew::VERSION = '0.48';
#ABSTRACT: Automated Perl building and installation for CPAN Testers

use strict;
use warnings;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

smokebrew - Automated Perl building and installation for CPAN Testers

=head1 VERSION

version 0.48

=head1 SYNOPSIS

  smokebrew --email tester@cpan.org --builddir /home/tester/pit/build --prefix /home/tester/pit/rel \
            --perlargs "-Dusethreads" --perlargs "-Duse64bitint" --mirrors http://cpan.hexten.net/ \
            --plugin App::SmokeBrew::Plugin::CPANPLUS::YACSmoke --recent --verbose

=head1 DESCRIPTION

smokebrew is a utility that builds, installs and configures perls for CPAN testing.

It downloads, extracts, patches ( if applicable ), configures, builds, tests and installs
perl versions and runs an specified L<App::SmokeBrew::Plugin> to configure the perl installation
for CPAN testing.

It accepts a number of command line switches or options options specified in a configuration file.

=head1 COMMAND LINE SWITCHES

=over

=item C<--configfile FILE>

Specify a configuration file to use. See L</CONFIGURATION FILE> for more details.

=item C<--builddir DIRPATH>

This is a required argument. This is the directory path that smokebrew will use for building and
configuration. If the path doesn't exist it will be created.

=item C<--prefix DIRPATH>

This is a required argument. This is the directory that will be the root for perl installations.
If the path doesn't exist it will be created.

  --prefix /home/cpan/pit/rel

In C</home/cpan/pit/rel> there will be a C<perl-version> for each perl that is installed.

  /home/cpan/pit/rel/perl-5.8.9
  /home/cpan/pit/rel/perl-5.10.0

  etc.

=item C<--email EMAILADDRESS>

This is a required argument. Must be a valid email address as constrained by L<MooseX::Types::Email>.
This will be passed to the given L<App::SmokeBrew::Plugin> when configuring the each perl for CPAN
Testing.

=item C<--mx MAILEXCHANGER>

This is an optional argument. Can be a FQDN, hostname or IP address and is a mail exchanger that should be
used instead of sending CPAN Test reports directly to C<perl.org> MX.
This will be passed to the given L<App::SmokeBrew::Plugin> when configuring the each perl for CPAN Testing

=item C<--plugin PLUGIN>

This is a required argument. Specify the L<App::SmokeBrew::Plugin> to use. Plugins are verified as installed
by using L<Module::Pluggable>. This is what will be used to configure each perl for CPAN Testing.
You may either specify the full plugin module name eg. L<App::SmokeBrew::Plugin::CPANPLUS::YACSmoke> or, for
convenience, specify the last part of the plugin without the L<App::SmokeBrew::Plugin> prefix,
eg. L<CPANPLUS::YACSmoke>.

=item C<--perlargs FLAG>

This is an optional argument. Specify a L<Configure> command line argument that should be passed through
when building each perl. There is no need to specify C<-Dprefix> or C<-Dusedevel> as smokebrew handles these for you.
This switch may be specified multiple times with different arguments.

  smokebrew --perlargs "-Dusethreads" --perlargs "-Duse64bitint"

This would pass the flags for building a threaded 64bit perl to L<Configure>.

=item C<--mirrors URL>

This is an optional argument. Specify the URL of a CPAN mirror that should be used for retrieving required files
during the build process and what will end up as the mirror list when the given L<App::SmokeBrew::Plugin> is run.
This switch may be specified multiple times with different arguments.

  smokebrew --mirrors http://cpan.hexten.net/ --mirrors http://cpan.cpantesters.org/

=item C<--verbose>

This an optional switch. Specify if smokebrew should produce verbose output about what it is doing.
By default it is silent.

=item C<--noclean>

This is an optional switch. Specify whether smokebrew should clean up in the C<builddir> as it
processes. The default is to be tidy.

=item C<--nozapman>

This is an optional switch. smokebrew usually removes the C<man> pages that are generated by the perl installation.
Specify this option if you wish the C<man> pages to be retained.

=item C<--skiptest>

This is an optional switch. Specify whether smokebrew should skip the C<make test> phase of building a
perl. The default is to run C<make test>.

=item C<--force>

This is an optional switch. By default if a perl installation already exists for a given perl version
smokebrew will skip over the build and configuration for that perl. Enabling this option will make
smokebrew zap the existing installation and build and configure again.

=item C<--forcecfg>

This is an optional switch. By default if a perl installation already exists for a given perl version
smokebrew will skip over the build and configuration for that perl. Enabling this option will make
smokebrew skip the build process, but enable reconfiguration.

=item C<--make MAKE>

This is an optional argument. Specify the C<make> executable that should be used. The default is C<make>.

=back

There are a number of options that allow you to specify what particular perl versions are installed.

Perls older than C<5.006> are not supported.

Perl versions C<5.6.0> and C<5.8.0> will also be filtered out as they are considered troublesome.

Without any of the following options, smokebrew will attempt to install all perls that are greater than or
equal to C<5.006> ( subject to the above filtering rules ).

Available perl releases are determined by use of L<Module::CoreList>, if you find that you haven't got
what you consider to be a full list, please update L<Module::CoreList> to latest version available from
CPAN.

=over

=item C<--recent>

This will indicate that you wish to only install C<recent> perls, which are stable perls that are greater than or
equal to C<5.8.9>. At the time of writing these were:

  5.8.9, 5.10.0, 5.10.1, 5.12.0, 5.12.1, 5.12.2, 5.12.3, 5.12.4, 5.12.5, 5.14.0, 5.14.1, 5.14.2,
  5.14.3, 5.16.0, 5.16.1 and 5.16.2

=item C<--stable>

This will indicate that you wish to only install C<stable> perls, which are perl releases with an even version number.

Examples:

  5.6.2
  5.8.9
  5.10.1
  5.12.1

=item C<--modern>

This will indicate that you wish to only install C<modern> perls, which are stable perls that are greater than or
equal to C<5.10.0>. At the time of writing these were:

  5.10.0, 5.10.1, 5.12.0, 5.12.1, 5.12.2, 5.12.3, 5.12.4, 5.12.5, 5.14.0, 5.14.1, 5.14.2,
  5.14.3, 5.16.0, 5.16.1 and 5.16.2

=item C<--latest>

This will indicate that you wish to only install the latest recent perls, which are stable perls that are greater than or
equal to C<5.8.9>. At the time of writing these were:

  5.8.9, 5.10.1, 5.12.5, 5.14.3, 5.16.2

=item C<--devel>

This will indicate that you wish to only install C<development> perls, which are perl development releases and have
an odd version number.

Examples:

  5.7.3
  5.9.5
  5.13.0

=item C<--install>

Specify a particular version of perl that you wish to install. This can be of the form C<perl-version> or C<version>.
This overrides the C<--recent>, C<--stable> and C<--devel> switches.

Example:

  --install perl-5.10.1

  --install 5.10.1

=back

=head1 CONFIGURATION FILE

All the command line switches may also be specifed in a configuration file ( except C<configfile> for
obvious reasons ).

The configuration file is C<INI> style format. L<App::SmokeBrew::IniFile> a subclass of L<Config::INI::Reader>
is used to read the file.

By default smokebrew looks for a directory in your C<HOME> directory called C<.smokebrew> and for a file
called C<smokebrew.cfg> within that directory.

Setting the environment variable C<PERL5_SMOKEBREW_DIR> will affect where smokebrew looks for the C<.smokebrew>
directory.

Command line switches will override anything specified in the configuration file, including multi-value parameters.
This is a feature of L<MooseX::Getopt>.

=head2 GLOBAL OPTIONS

=over

=item C<builddir=DIRPATH>

This is a required argument. This is the directory path that smokebrew will use for building and
configuration. If the path doesn't exist it will be created.

  builddir=/home/cpan/pit/build

=item C<prefix=DIRPATH>

This is a required argument. This is the directory that will be the root for perl installations.
If the path doesn't exist it will be created.

  prefix=/home/cpan/pit/rel

=item C<email=EMAILADDRESS>

This is a required argument. Must be a valid email address as constrained by L<MooseX::Types::Email>.
This will be passed to the given L<App::SmokeBrew::Plugin> when configuring the each perl for CPAN
Testing.

  email=foo@bar.com

=item C<mx=MAILEXCHANGER>

This is an optional argument. Can be a FQDN, hostname or IP address and is a mail exchanger that should be
used instead of sending CPAN Test reports directly to C<perl.org> MX.
This will be passed to the given L<App::SmokeBrew::Plugin> when configuring the each perl for CPAN Testing

  mx=mx.foo.com

=item C<plugin=PLUGIN>

This is a required argument. Specify the L<App::SmokeBrew::Plugin> to use. Plugins are verified as installed
by using L<Module::Pluggable>. This is what will be used to configure each perl for CPAN Testing.
You may either specify the full plugin module name eg. L<App::SmokeBrew::Plugin::CPANPLUS::YACSmoke> or, for
convenience, specify the last part of the plugin without the L<App::SmokeBrew::Plugin> prefix,
eg. L<CPANPLUS::YACSmoke>.

  plugin=App::SmokeBrew::Plugin::CPANPLUS::YACSmoke

or

  plugin=CPANPLUS::YACSmoke

=item C<perlargs=FLAG>

This is an optional argument. Specify a L<Configure> command line argument that should be passed through
when building each perl. There is no need to specify C<-Dprefix> or C<-Dusedevel> as smokebrew handles these for you.
This switch may be specified multiple times with different arguments.

  perlargs=-Dusethreads
  perlargs=-Duse64bitint

This would pass the flags for building a threaded 64bit perl to L<Configure>.

=item C<mirrors=URL>

This is an optional argument. Specify the URL of a CPAN mirror that should be used for retrieving required files
during the build process and what will end up as the mirror list when the given L<App::SmokeBrew::Plugin> is run.
This switch may be specified multiple times with different arguments.

  mirrors=http://cpan.hexten.net/
  mirrors=http://cpan.cpantesters.org/

=item C<verbose=BOOL>

This an optional switch. Specify if smokebrew should produce verbose output about what it is doing.
By default it is silent.

  verbose=1

=item C<noclean=BOOL>

This is an optional switch. Specify whether smokebrew should clean up in the C<builddir> as it
processes. The default is to be tidy.

  noclean=1

=item C<nozapman=BOOL>

This is an optional switch. smokebrew usually removes the C<man> pages that are generated by the perl installation.
Specify this option if you wish the C<man> pages to be retained.

  nozapman=1

=item C<skiptest=BOOL>

This is an optional switch. Specify whether smokebrew should skip the C<make test> phase of building a
perl. The default is to run C<make test>.

  skiptest=1

=item C<make=MAKE>

This is an optional argument. Specify the C<make> executable that should be used. The default is C<make>.

  make=gmake

=back

There are a number of options that allow you to specify what particular perl versions are installed.

Perls older than C<5.006> are not supported.

Perl versions C<5.6.0> and C<5.8.0> will also be filtered out as they are considered troublesome.

Without any of the following options, smokebrew will attempt to install all perls that are greater than or
equal to C<5.006> ( subject to the above filtering rules ).

Available perl releases are determined by use of L<Module::CoreList>, if you find that you haven't got
what you consider to be a full list, please update L<Module::CoreList> to latest version available from
CPAN.

=over

=item C<recent=BOOL>

This will indicate that you wish to only install C<recent> perls, which are stable perls that are greater than or
equal to C<5.8.9>. At the time of writing these were:

  5.8.9, 5.10.0, 5.10.1, 5.12.0 and 5.12.1

=item C<stable=BOOL>

This will indicate that you wish to only install C<stable> perls, which are perl releases with an even version number.

Examples:

  5.6.2
  5.8.9
  5.10.1
  5.12.1

=item C<devel=BOOL>

This will indicate that you wish to only install C<development> perls, which are perl development releases and have
an odd version number.

Examples:

  5.7.3
  5.9.5
  5.13.0

=back

=head2 PLUGIN CONFIGURATION

Options to be passed to plugins may be specified under named sections in the configuration file.

You may either specify the full plugin module name as the section name
eg. L<App::SmokeBrew::Plugin::CPANPLUS::YACSmoke> or, for
convenience, specify the last part of the plugin without the L<App::SmokeBrew::Plugin> prefix,
eg. L<CPANPLUS::YACSmoke>.

  [Random::Plugin]

  someopt = foobar

=head1 KUDOS

GUGOD for perlbrew, which inspired this utility ( and obviously gave it its name ).

Florian Ragwitz for assistance with coercing an arrayref of URIs.

H.Merijn Brand for mentioning L<Devel::PPPort>'s buildperl.pl, which I stole for L<Devel::PatchPerl>
which smokebrew uses to patch older perls.

L<Moose> for making this possible.

=head1 SEE ALSO

L<Module::CoreList>

L<MooseX::Types::Email>

L<App::SmokeBrew::Plugin>

=head1 AUTHOR

Chris Williams <chris@bingosnet.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Chris Williams.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut