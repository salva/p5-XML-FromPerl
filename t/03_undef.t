#!perl

use strict;
use warnings;
use XML::LibXML;
use XML::FromPerl qw(xml_from_perl xml_node_from_perl);
use Test::More;
use Test::Warn;
use Tie::IxHash;

my $doc = xml_from_perl
    [ Foo =>
        [ Bar =>
            undef,
            'Baz',
            undef,
            'Quux',
        ]
    ];

like $doc->toString, qr{<Foo><Bar>BazQuux</Bar></Foo>},
    'undef element is skipped';
    # like(), not is(), because there's also an XML processing instruction.

$doc = xml_from_perl undef;
ok $doc, 'undef in -> document out';
ok !defined $doc->documentElement, 'undef in -> no documentElement out';

warning_like { xml_from_perl undef } qr/document.*undefined/,
    'xml_from_perl(undef) warns by default';

{
    no warnings 'XML::FromPerl::undefined';
    warning_is { xml_from_perl undef } undef,
        'XML::FromPerl::undefined warning category works';
}

{
    no warnings 'XML::FromPerl';
    warning_is { xml_from_perl undef } undef,
        'XML::FromPerl warning category works';
}

$doc = XML::LibXML::Document->new;
warning_like { xml_node_from_perl $doc, undef } qr/node.*undefined/,
    'xml_node_from_perl(undef) warns by default';

{
    no warnings 'XML::FromPerl::undefined';
    warning_is { xml_node_from_perl $doc, undef } undef,
        'XML::FromPerl::undefined warning category works in xml_node_from_perl';
}

{
    no warnings 'XML::FromPerl';
    warning_is { xml_node_from_perl $doc, undef } undef,
        'XML::FromPerl warning category works in xml_node_from_perl';
}

$doc = XML::LibXML::Document->new;
my $el = xml_node_from_perl($doc, undef);
ok !defined $el, 'No data -> undefined node';
done_testing;
