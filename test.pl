#!/usr/bin/perl
use feature 'say';

my $p = `openssl passwd -crypt aniaania`;
say $p;
chomp($p);
say $p;
