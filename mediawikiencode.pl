#!/usr/bin/perl
# Uses pbpaste and pbcopy (e.g. on OS X) if no argument given.
# Otherwise provide file or "-" to read from STDIN.

# Check whether pbaste exists
($path = `which pbpaste`)=~ s/\n//;

if ($#ARGV == -1) {
    if ($path ne "") {
	print STDERR "Reading from clipboard.\n";
	$_ = `pbpaste`;
    } else {
	print STDERR "Please supply file as argument or - to read from STDIN.\n";
    };
} else {
    open F,$ARGV[0];
    while ($line=<F>) {
	$_ .= $line;
    };
    close F;
};

# replace {,{{,}},}
%replace = qw'{{ {{((}}
{ {{(}}
}} {{))}}
} {{)}}';
@find = keys %replace;
&replace;

# replace ||,|
%replace = qw'|| {{!!}}
| {{!}}';
@find = qw'\|\| \|';
&replace;

# Replace =,; if needed - currently commented out, and so it's not used.
%replace = qw'= {{=}}
; {{;}}';
@find = keys %replace;
#&replace;

# Print results
print;

if ($path ne "") {
    print STDERR "Pasting to clipboard.\n";
# Put results back on pasteboard;
    open F,"|pbcopy";
    print F;
    close F;
};


sub replace {
    $patt = join "|",@find;
    s/($patt)/$replace{$1}/sg;
};

__END__

Example:

{...SINGLE...}
{{...DOUBLE...}}
{{{...TRIPLE...}}}
|...SINGLE BAR...|
||...DOUBLE BAR...||
|||...TRIPLE BAR...|||
;...SEMICOLON...;
=...EQUALS...=

