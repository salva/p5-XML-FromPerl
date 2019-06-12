#!perl
use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Spec;

my $VERSION_FROM = File::Spec->catfile(qw(lib XML FromPerl.pm));

my %opts =  (  NAME          => 'XML::FromPerl',
               VERSION_FROM  => $VERSION_FROM,
               PREREQ_PM     => { 'XML::LibXML' => 0 },
               ABSTRACT_FROM => $VERSION_FROM,
               AUTHOR        => 'Salvador Fandiño <salva@cpan.org>',
               LICENSE       => 'perl',

               CONFIGURE_REQUIRES => {
                   'ExtUtils::MakeMaker' => '0',
                   'File::Spec' => '0',
               },

               TEST_REQUIRES => {
                   'Test::More' => '0',
                   'Test::Warn' => '0',
                   'Tie::IxHash' => '0',
               },

               META_MERGE    => {
                'meta-spec' => { version => 2 },

                resources => {
                    bugtracker => {
                        web  => 'https://github.com/salva/p5-XML-FromPerl/issues',
                    },
                    repository => {
                        type => 'git',
                        url  => 'https://github.com/salva/p5-XML-FromPerl.git',
                        web  => 'https://github.com/salva/p5-XML-FromPerl',
                    },
                },

                prereqs => {
                    develop => {
                        recommends => {
                            'App::RewriteVersion' => '0',   # for perl-bump-version
                            'Devel::Cover' => '0',
                        },
                    },
                },

                provides => {
                    'XML::FromPerl' => {
                        file => join "/", File::Spec->splitdir($VERSION_FROM),
                    },
                },

                x_contributors => [
                    'Christopher White <cxw@cpan.org>',
                ],
               },
            );

WriteMakefile(%opts);
