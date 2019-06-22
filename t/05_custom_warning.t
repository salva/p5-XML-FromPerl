#!perl

use strict;
use XML::LibXML;
use XML::FromPerl qw(xml_from_perl xml_node_from_perl);
use Test::More;
use Test::Warn;
use Tie::IxHash;
use warnings;   # After the `use XML::FromPerl`
                # per https://rt.perl.org/Public/Bug/Display.html?id=128765

BEGIN {
    plan skip_all => 'Custom warning categories not supported before 5.014'
        if $] lt '5.014';
}

warning_like { xml_from_perl undef } qr/document.*undefined/,
    'xml_from_perl(undef) warns by default when warnings are enabled';

eval {
    no warnings 'XML::FromPerl::undefined';
    warning_is { xml_from_perl undef } undef,
        'XML::FromPerl::undefined warning category works';
};

eval {
    no warnings 'XML::FromPerl';
    warning_is { xml_from_perl undef } undef,
        'XML::FromPerl warning category works';
};

my $doc = XML::LibXML::Document->new;
warning_like { xml_node_from_perl $doc, undef } qr/node.*undefined/,
    'xml_node_from_perl(undef) warns by default when warnings are enabled';

eval {
    no warnings 'XML::FromPerl::undefined';
    warning_is { xml_node_from_perl $doc, undef } undef,
        'XML::FromPerl::undefined warning category works in xml_node_from_perl';
};

eval {
    no warnings 'XML::FromPerl';
    warning_is { xml_node_from_perl $doc, undef } undef,
        'XML::FromPerl warning category works in xml_node_from_perl';
};

done_testing;
