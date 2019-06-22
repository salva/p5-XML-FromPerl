#!perl

use strict;
use XML::FromPerl qw(xml_from_perl);
use Test::More;
use Tie::IxHash;
use warnings;

my $doc = xml_from_perl
    [ Foo =>
        ['!--', 'comment'],
        [ Bar =>
            'Baz',
            'Quux',
        ],
        ['!--', 'comment2'],
    ];

like $doc->toString,
    qr{<Foo><!--comment--><Bar>BazQuux</Bar><!--comment2--></Foo>},
    'comments are added';

isa_ok $doc->documentElement->firstChild, 'XML::LibXML::Comment';

$doc = xml_from_perl
    [ Foo =>
        '<!-- not a comment',
        [ 'Bar' ],
        'also not a comment -->',
        [ 'Baz' ],
        '<!--still text-->',
    ];

like $doc->toString,
    qr{<Foo>&lt;!-- not a comment<Bar(/>|>\s*</Bar>)also not a comment --&gt;<Baz(/>|>\s*</Baz>)&lt;!--still text--&gt;</Foo>},
    'strings with comment markers are text nodes';

{
    local $, = '#';
    $doc = xml_from_perl [ Foo => [ '!--', 'a'..'d' ] ];
    like $doc->toString, qr{<Foo><!--a\#b\#c\#d-->}, '$, used';
}

{
    local $,='#';
    $doc = xml_from_perl [ Foo => [ '!--', 'a', undef, 'b', undef, 'c' ] ];
    like $doc->toString, qr{<!--a\#b\#c-->}, 'undefs skipped in comment';
}

$doc = xml_from_perl [ Foo => [ '!--', {attr=>42}, 'a', ] ];
like $doc->toString, qr{<!--a-->}, 'attributes skipped in comment';

done_testing;
