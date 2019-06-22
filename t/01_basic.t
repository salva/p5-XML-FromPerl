#!perl

use strict;
use XML::LibXML;

use XML::FromPerl qw(xml_from_perl xml_node_from_perl);
use Test::More;
use warnings;

sub testname {
    my (undef, undef, $line) = caller;
    "(line $line)"
}

# === xml_from_perl ===

# Example from the perldoc, modified
my $doc = xml_from_perl
    [ Foo => { attr1 => 42, attr2 => 1337 },
        [ Bar => { attr3 => "hello", non_existent_attr => undef } ],
        [ Bar => "Whatever" ],
        "Some Text here",
        [ Doz => { attr4 => "something" },
            [ Quux => { attr5 => "else" },
                [ "yep" ],
                "bye!"
            ]
        ] ,
    ];

my @tests_children_Foo = (
    {
        nodeName => 'Bar',
        textContent => '',
        _attrs => { attr3 => 'hello' },
    },
    {
        nodeName => 'Bar',
        textContent => 'Whatever',
    },
    {
        textContent => 'Some Text here',
    },
    {
        nodeName => 'Doz',
        _attrs => { attr4 => 'something' },
    },
);

# Basic checks
ok $doc, 'Document created';
ok $doc->toString, 'Document stringifies';

my $root = $doc->documentElement;
is $root->nodeName, 'Foo', testname;
ok $root->hasAttributes, testname;

# Check root attributes
my @attrs = $root->attributes;
cmp_ok @attrs, '==', 2, testname;
foreach my $attr (@attrs) {
    ok $attr->nodeName eq 'attr1' || $attr->nodeName eq 'attr2', testname;
    if($attr->nodeName eq 'attr1') {
        cmp_ok $attr->value, '==', 42, testname;
    } else {
        cmp_ok $attr->value, '==', 1337, testname;
    }
}

# Check the first-level children
my $child = $root->firstChild;
my $childidx = 0;
while($child) {
    my %test = %{$tests_children_Foo[$childidx]};
    foreach my $k (keys %test) {
        if($k ne '_attrs') {
            is $child->$k, $test{$k}, testname;
        } else {    # attributes
            my %expected = %{$test{$k}};
            @attrs = $child->attributes;
            cmp_ok @attrs, '==', keys %expected, testname;
            foreach my $got_attr (@attrs) {
                is $got_attr->value,
                    $expected{$got_attr->nodeName} || '!!OOPS!!',
                    "Attribute $got_attr";
            }
        }
    }
    $child = $child->nextSibling;
    ++$childidx;
}

# Check Doz
$child = $root->lastChild;
is $child->nodeName, 'Doz', testname;

# Check Doz's children
$child = $child->firstChild;
is $child->nodeName, 'Quux', testname;
@attrs = $child->attributes;
cmp_ok @attrs, '==', 1, testname;
is $attrs[0]->nodeName, 'attr5', testname;
is $attrs[0]->value, 'else', testname;

$child = $child->firstChild;
is $child->nodeName, 'yep', testname;

$child = $child->nextSibling;
is $child->textContent, "bye!", testname;

# === xml_node_from_perl ===

$doc = XML::LibXML::Document->new;
my $el = xml_node_from_perl($doc, [ Foo => {attr=>42}, '1337' ]);
is $el->toString, '<Foo attr="42">1337</Foo>', testname;

done_testing;
