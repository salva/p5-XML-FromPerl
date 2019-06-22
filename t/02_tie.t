#!perl

use strict;
use XML::FromPerl qw(xml_from_perl);
use Test::More;
use Tie::IxHash;
use warnings;

sub testname {
    my (undef, undef, $line) = caller;
    "(line $line)"
}

tie my(%attrs), 'Tie::IxHash';
$attrs{z} = 'hello';
$attrs{a} = 'world';

my $doc = xml_from_perl [
    Foo => \%attrs,
];

like $doc->toString,
    qr{<Foo\s+z=['"]hello['"]\s+a=['"]world['"](/>|>\s*</Foo>)},
    'Attributes come out in order from tied hash';

done_testing;
