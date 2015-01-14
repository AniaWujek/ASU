package latexTab;
use strict;

#Anna Wujek
#ASU, sroda 8.15 - 10.00
#projekt 1, zadanie 9

sub makeHeader
{
    my $file_desc = @_[0];
    printf($file_desc "\\documentclass[11pt]{article}\n");
    printf($file_desc "\\begin{document}\n");
}
sub makeEnd
{
    my $file_desc = @_[0];
    printf($file_desc "\\end{document}\n");
    
}
sub makeTabHeader
{
    my $file_desc = @_[0];
    printf($file_desc "\t\\begin{table}[t]\n");
    printf($file_desc "\t\t\\caption{}\n");
    printf($file_desc "\t\t\\label{}\n");
}
sub makeTabEnd
{
    my $file_desc = @_[0];
    printf($file_desc "\t\t\\end{tabular}\n");
    printf($file_desc "\t\\end{table}\n");
}
sub beginTabular
{
    my $texFileDesc = @_[0];
    my $tabFileDesc = @_[1];
    my $columnHead = @_[3];
	my $inv = @_[2];
	my $align = @_[4];	
    my $columns = getColumns($tabFileDesc, $inv);
    
    if($columnHead == 1)
    {
        $columns = $columns + 1;
    }
    
    my $tabs = ( "|" . $align ) x $columns;
    $tabs = $tabs . "|";
    $tabs = "\t\t\\begin{tabular}{" . $tabs . "}\n";
    printf($texFileDesc $tabs);
    
    return $columns;
}
sub checkIfMetaChar
{
    my $character = @_[0];
    
    my @metaChar = ("\^", "\$", "\(", "\)", "\\", "\|", "\@", "\[", "\{", "\?", "\.", "\+", "\*");
    if($character ~~ @metaChar )
    {
       return 1;
    }
    return 0;
}
sub getColumns
{
    my $max = 0;
    my $tabFileDesc = @_[0];
    seek($tabFileDesc, 0, 0);
	my $inv = @_[1];
    my $row = <$tabFileDesc>;
    
    chomp $row;
    my $splitChar = $row;  

    if(checkIfMetaChar($splitChar) == 1)
    {
        $splitChar = "\\".$splitChar;
    }  
    while($row = <$tabFileDesc>)
    {
        chomp $row;
		if($inv == 1)
		{
			$max = $max + 1;
		}
		else
		{
			my $r = split($splitChar, $row);
			if($r > $max)
			{
				$max = $r;
			} 
		}
    }   
    return $max;   
}
sub newLine
{
    my $file_desc = @_[0];
    printf($file_desc "\t\t\\hline\n");
}
sub makeTable
{
    my $texFileDesc = @_[0];
    my $tabFileDesc = @_[1];
    seek($tabFileDesc, 0, 0);
	my $inv = @_[2];
	my $columns = @_[3];
	my $rowHead = @_[4];
	my $columnHead = @_[5];

    my $row = <$tabFileDesc>;
    
    chomp $row;
    my $splitChar = $row;
    
    if(checkIfMetaChar($splitChar) == 1)
    {
        $splitChar = "\\".$splitChar;
    }
    
    printf($texFileDesc "\t\t\t\\hline\n");
    if($rowHead == 1)
    {
        printf($texFileDesc "\t\t\t"." & " x ($columns-1) . "\\\\\n\t\t\t\\hline\n");
    }  
	my @lines;
	while(<$tabFileDesc>)
	{
		push(@lines, $_);
	}  
	
	my $colH = "";
	my $colHead;
	if($columnHead == 1)
	{
	    $colHead = "& ";
	}
	
	if($inv == 0)
	{		
		foreach my $line (@lines)
		{	
		    my $s = split($splitChar, $line);		
			$line =~ s/$splitChar/ & /g;
			
			$s = $columns - $s;
			if($columnHead == 1)
			{
			    $s = $s - 1;
			}
            chomp $line;
			printf($texFileDesc "\t\t\t".$colHead.$line. " & " x $s . "\\\\ \n\t\t\t\\hline\n");
		}
	}  
	else
	{
		my @newLines;
		my $amp = "";
		my $s;
		foreach my $line (@lines)
		{
		    chomp $line;
		    
			my @splitLine = split($splitChar, $line);
			my $size = @splitLine;
			
			for(my $i = 0; $i < $size; $i = $i + 1)
			{
				@newLines[$i] .= $amp.@splitLine[$i];
			}
			$amp = " & ";
		}
		foreach my $line (@newLines)
		{
		    my $s = split("&", $line);
		    $s = $columns - $s;
		    if($columnHead == 1)
			{
			    $s = $s - 1;
			}
            chomp $line;
		    printf($texFileDesc "\t\t\t".$colHead.$line. " & " x $s . "\\\\ \n\t\t\t\\hline\n");
		}		
	}
}
sub checkTabFile
{
    my $tabFileDesc = @_[0];
    my $lines = 0;
    my $firstLine = 1;
    while(<$tabFileDesc>)
    {
        if($firstLine == 1)
        {
            $firstLine = 0;
            chomp $_;
            if( length($_) != 1 )
            {
                return 0;
            }
        }
        $lines = $lines + 1;
        chomp $_;
        if(length($_) == 0)
        {
            return 0;
        }
        if($lines >= 2)
        {
            return 1;
        }
    }
    return 0;
}
1;

