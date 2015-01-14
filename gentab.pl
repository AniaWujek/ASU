#!/usr/bin/perl

#Anna Wujek
#ASU, sroda 8.15 - 10.00
#projekt 1, zadanie 9

use latexTab;
use strict;

my $inv = 0;
my $rowHead = 0;
my $columnHead = 0;
my $ok = 0;
my $texFile = "";
my $tabFile = "";
my $align = "c";
my $texFileDesc;
my $tabFileDesc;
my $columns;

while(my $arg = shift(@ARGV))
{
    if($arg eq "-h")
    {
        print "\n************ gentab.pl **************\n";
        print "Generowanie tabeli w Latexu\n";
        print "Skladnia:\n";
        print "perl gentab [plik tex] [plik konfiguracyjny] [opcje]\n";
        print "-tex plik_tex\n-conf plik_konfiguracyjny\n-inv - odwroc tabele\n";
        print "-rowH - wstaw naglowki dla wierszy\n";
        print "-colH - wstaw naglowki dla kolumn\n";
        print "-align [c r l] - wyrownanie w komorkach\n";
        print "np. perl gentab.pl -tex plik -conf tab -inv -align c\n\n";
        exit;
    }
    elsif($arg eq "-inv")
    {
        $inv = 1;
    }
    elsif($arg eq "-colH")
    {
        $rowHead = 1;
    }
    elsif($arg eq "-rowH")
    {
        $columnHead = 1;
    }
    elsif($arg eq "-tex")
    {        
        if($arg = shift(@ARGV))
        {            
            unless( $arg =~ m/.tex$/ )
            {
                $arg = $arg . ".tex";
            }
            
            $texFile = $arg;
            if(-e $texFile)
            {
                print "\nplik .tex istnieje! wybierz inna nazwe\n";
                exit;
            }
            $ok = $ok + 1;
        }
        else
        {
            print "\nnieprawidlowa skladnia!\nperl gentab -h aby zobaczyc help\n";
            exit;
        }
    }
    elsif($arg eq "-conf")
    {
        if($arg = shift(@ARGV))
        {
            $tabFile = $arg;
            if(!(-e $tabFile))
            {
                print "\nplik konfiguracyjny nie istnieje!\n";
                exit;
            }
            $ok = $ok + 1;
        }
        else
        {
            print "\nnieprawidlowa skladnia!\nperl gentab -h aby zobaczyc help\n";
            exit;
        }
    }
    elsif($arg eq "-align")
    {
        if($arg = shift(@ARGV))
        {
            if($arg eq "r" or $arg eq "l" or $arg eq "c" )
            {
                $align = $arg;
            }
            else
            {
                print "\nalign: l, r lub c\nperl gentab -h aby zobaczyc help\n";
                exit;
            }
        }
        else
        {
            print "\nnieprawidlowa skladnia!\nperl gentab -h aby zobaczyc help\n";
            exit;
        }
    }
    else
    {
        print "\nnieprawidlowa skladnia! \nperl gentab -h aby zobaczyc help\n";
        exit;
    }
}
if($ok != 2)
{
    print "\nnieprawidlowa skladnia!\nperl gentab -h aby zobaczyc help\n";
    exit;
}
open($tabFileDesc, "<", $tabFile) or die;
if( latexTab::checkTabFile($tabFileDesc) == 0)
{
    print "\nnieprawidlowy plik konfiguracyjny!\nPierwsza linia pliku to jednoznakowy separator, w kolejnych wierszach kolejne wiersze tabeli\n";
    close(tabFileDesc);
    exit;
}
open($texFileDesc, ">", $texFile) or die;

latexTab::makeHeader($texFileDesc);
latexTab::makeTabHeader($texFileDesc);
$columns = latexTab::beginTabular($texFileDesc, $tabFileDesc, $inv, $columnHead, $align);
latexTab::makeTable($texFileDesc, $tabFileDesc, $inv, $columns, $rowHead, $columnHead);
latexTab::makeTabEnd($texFileDesc);
latexTab::makeEnd($texFileDesc);

close(texFileDesc);
close(tabFileDesc);
exit;
