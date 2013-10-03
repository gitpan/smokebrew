
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Automated Perl building and installation for CPAN Testers",
  "AUTHOR" => "Chris Williams <chris\@bingosnet.co.uk>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "smokebrew",
  "EXE_FILES" => [
    "bin/smokebrew"
  ],
  "LICENSE" => "perl",
  "NAME" => "smokebrew",
  "PREREQ_PM" => {
    "Archive::Extract" => "0.40",
    "CPAN::Perl::Releases" => "0.02",
    "Config::INI::Reader" => "0.014",
    "Devel::PatchPerl" => "0.24",
    "File::Fetch" => "0.24",
    "File::Path" => "2.08",
    "File::Spec" => "3.31",
    "File::pushd" => "1.00",
    "IPC::Cmd" => "0.58",
    "List::MoreUtils" => "0.22",
    "Log::Message::Simple" => "0.06",
    "Module::CoreList" => "2.49",
    "Module::Load::Conditional" => "0.38",
    "Module::Pluggable" => "3.9",
    "Moose" => "1.03",
    "Moose::Role" => "1.03",
    "Moose::Util::TypeConstraints" => "1.03",
    "MooseX::ConfigFromFile" => "0.02",
    "MooseX::Getopt" => "0.27",
    "MooseX::Types::Email" => "0.003",
    "MooseX::Types::Moose" => "0.21",
    "MooseX::Types::Path::Class" => "0.05",
    "MooseX::Types::URI" => "0.03",
    "Parse::CPAN::Meta" => "1.40",
    "Perl::Version" => "1.009",
    "URI" => "1.54"
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::More" => 0
  },
  "VERSION" => "0.46",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



