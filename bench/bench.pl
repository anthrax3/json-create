#!/home/ben/software/install/bin/perl

# Benchmark JSON::Create against JSON::XS.

use warnings;
use strict;
use utf8;
use Benchmark ':all';
use FindBin '$Bin';

# Just so I can use the latest versions

use lib '/home/ben/projects/json-create/blib/lib';
use lib '/home/ben/projects/json-create/blib/arch';

# Contenders

use JSON::Create 'create_json';
use JSON::XS;
use Cpanel::JSON::XS;

# Number of repetitions. No matter how large this is made, the results
# always vary wildly from run to run.

my $count = 100;
# The results seem to stabilize better if we run the inner loop a
# number of times. Still, unfortunately, setting this very large
# doesn't stabilize the results completely.
my $inner = 10000;

print "Versions used:\n\n";
my @modules = qw/Cpanel::JSON::XS JSON::XS JSON::Create/;
for my $module (@modules) {
    my $abbrev = $module;
    $abbrev =~ s/(\w)\w+\W*/$1/g; 
    my $version = eval "\$${module}::VERSION";
    print "$abbrev\t$module\t$version\n";
}

# ASCII string test

my $stuff = {
    captain => 'planet',
    he => "'s",
    a => 'hero',
    gonna => 'take',
    pollution => 'down',
    to => 'zero',
    "he's" => 'our',
    powers => 'magnified',
    and => "he's",
    fighting => 'on',
    the => "planet's",
    side => "Captain Planet!",
};

header ("hash of ASCII strings");

cmpthese (
    $count,
    {
	'JC' => sub {
	    for (1..$inner) {
		my $x = JSON::Create::create_json ($stuff);
	    }
	},
	'JX' => sub {
	    for (1..$inner) {
		my $x = JSON::XS::encode_json ($stuff);
	}
	},
	'CJX' => sub {
	    for (1..$inner) {
		my $x = Cpanel::JSON::XS::encode_json ($stuff);
	    }
	},
    },    
);

my $h2n = {
    a => 1,
    b => 2,
    c => 4,
    d => 8,
    e => 16,
    f => 32,
    g => 64,
    h => 128,
    i => 256,
    j => 512,
    k => 1024,
    l => 2048,
    m => 4096,
    n => 8192,
    o => 16384,
    p => 32768,
    q => 65536,
    r => 131_072,
    s => 262_144,
    t => 524_288,
    u => 1_048_576,
    v => 2_097_152,
    w => 4_194_304,
    x => 8_388_608,
    y => 16_777_216,
    z => 33_554_432,
    A => 67_108_864,
    B => 134_217_728,
    C => 268_435_456,
    D => 536_870_912,
    E => 1_073_741_824,
};

header ("hash of integers");

cmpthese (
    $count,
    {
	'JC' => sub {
	    for (1..$inner) {
		my $x = JSON::Create::create_json ($h2n);
	    }
	},
	'JX' => sub {
	    for (1..$inner) {
		my $x = JSON::XS::encode_json ($h2n);
	    }
	},
	'CJX' => sub {
	    for (1..$inner) {
		my $x = Cpanel::JSON::XS::encode_json ($h2n);
	    }
	},
    },    
);

use utf8;

my %unihash = (
    'う' => '雨',
    'あ' => '亜',
    'い' => '井',
    'え' => '絵',
    'お' => '尾',
    'ば' => [
	qw/場 馬 羽 葉 刃/
    ],
);


header ("hash of Unicode strings");

cmpthese (
    $count,
    {
	'JC' => sub {
	    for (1..$inner) {
		my $x = JSON::Create::create_json (\%unihash);
	    }
	},
	'JX' => sub {
	    for (1..$inner) {
		my $x = JSON::XS::encode_json (\%unihash);
	    }
	},
	'CJX' => sub {
	    for (1..$inner) {
		my $x = Cpanel::JSON::XS::encode_json (\%unihash);
	    }
	},
    },    
);

header ("array of floats");

my $floats = [1.0e-10, 0.1, 1.1, 9e9, 3.141592653,-1.0e-20,-9e19,];

cmpthese (
    $count,
    {
	'JC' => sub {
	    for (1..$inner) {
		my $x = JSON::Create::create_json ($floats);
	    }
	},
	'JX' => sub {
	    for (1..$inner) {
		my $x = JSON::XS::encode_json ($floats);
	    }
	},
	'CJX' => sub {
	    for (1..$inner) {
		my $x = Cpanel::JSON::XS::encode_json ($floats);
	    }
	},
    },    
);
exit;

sub header
{
    my ($head) = @_;
    print "\nComparing $head...\n\n";
}
