#!/usr/bin/perl
use strict;
use Getopt::Long;
use feature 'say';
use String::MkPasswd qw(mkpasswd);
use Tk;
use File::Copy;

# setup my defaults
my $user = '';
my $create = '';
my $passwd = '';
my $help = '';
my $uid = '';
my $randpasswd = '';
my $copydir = '';
my $save = '';
my $groupadd = '';
my $groupdel = '';
my $delete = '';
my $interactive = '';
my $shell = '';


GetOptions(
    'user=s'          => \$user,
    'create=s'      => \$create,
    'passwd=s'      => \$passwd,
    'uid=s'         => \$uid,
    'help!'         => \$help,
    'randpasswd'    => \$randpasswd,
    'copydir=s'     => \$copydir,
    'save=s'        => \$save,
    'groupadd=s'    => \$groupadd,
    'groupdel=s'    => \$groupdel,
    'delete=s'      => \$delete,
    'interactive'   => \$interactive,
    'shell=s'         => \$shell,
    
) or die "Incorrect usage!\n";

#jezeli tworzymy nowego uzytkownika
if ($create ne '') {
    
    my $ret;
    my $newuid;

    my $command = '-d /home/' . $create . ' -m ' . $create;
    
    
    #dajemy mu UID
    if($uid ne '') {
        my $ok = uid_free($uid);
        if ($ok == 1) {
            $newuid = $uid;
            $command = '-u ' . $uid . ' ' . $command; 
        }
        else {
            $newuid = getUID();  
            say 'Brak takiego UID! Twoje UID to ' . $newuid;      
            $command = '-u ' . $newuid . ' ' . $command;
        }
    }
    else {
        $newuid = getUID();
        
        $command = '-u ' . $newuid . ' ' . $command; 
    }    
    
    #dajemy mu haslo
    if($passwd ne '') {
        my $pass = `openssl passwd -crypt $passwd`;
        chomp($pass);
        $command = '-p ' . $pass . ' ' . $command;
    }
    elsif ($randpasswd) {
        my $pass = mkpasswd();
        $passwd = $pass;
        $pass = `openssl passwd -crypt "$pass"`;
        chomp($pass);
        say 'Twoje haslo to ' . $passwd;
        $command = '-p ' . $pass . ' ' . $command;
    }
    
    
    
    $ret = `useradd $command`;
    say $ret;
    #zapisanie danych
    if($save ne '' && $ret eq '') {
        my $fileDesc;
        my $file = $save;
        open($fileDesc, ">>", $file) or die 'Nie udalo sie otworzyc pliku do zapisu';
        
        my $toprint = 'login: ' . $create . ' uid: ' . $newuid . ' haslo: ' . $passwd . "\n";
        printf($fileDesc $toprint);
        close($fileDesc);
        `chmod 700 $file`;
    }
    #say 'useradd ' . $command;
        
}

#modyfikacja uzytkownika
elsif($user ne '') {

    #dodajemy do grupy
    if($groupadd ne '') {
        my $ret; 
        $ret = `gpasswd -a $user $groupadd`;
        say $ret;
        #say "gpasswd -a " . $user . " " . $groupadd;
    }
    
    #usuwamy z grupy
    if($groupdel ne '') {
        my $ret; 
        $ret = `gpasswd -d $user $groupdel`;
        say $ret;
        #say "gpasswd -d " . $user . " " . $groupdel;
    }
    
    #zmiana shella
    if($shell ne '') {
        my $ret;
        $ret = `chsh -s $shell $user`;
        say $ret;
        #say 'chsh -s ' . $shell . ' ' .$user;
    }
    
    #kopiowanie plikow kropkowych
    if($copydir ne '') {
        
        my $source = $copydir;
        my $dest = '/home/' . $user;
        
        opendir(my $DIR, $source) || die 'nieprawidlowy katalog ' . $source . '!';
        my @files = readdir($DIR);
        foreach my $file (@files) {
            
            if (-f $source . '/' . $file) {
                if( $file ne '.' && $file ne '..' ) {
                    copy($source . '/' . $file, $dest . '/.' . $file) or die 'Kopiowanie nie udalo sie!';
                    #say 'copy(' . $source . '/' . $file . ',' . $dest . '/.' . $file . ')';
                }
                
            }
        }
        closedir($DIR);
    }
    
    
    

}

#usuwamy uzytkownika
elsif($delete) {
    my $ret;    
    $ret = `userdel -r $delete`;
    say $ret;
    #say "userdel -r " . $delete;
}

else {
    my $help = '
    perl users.pl [opcje]
    -user login [-groupadd group] [-groupdel group]
        [-shell shell] [-copydir dir] 
    -create login [-uid uid] [-save file]
        [-passwd password] | [-randpasswd]
    -help
    -delete login';
    say $help;
}

#czy uid jest wolny
sub uid_free {
    my $newuid = @_[0];
    while (my ($name, $pass, $uid, $gid, $quota, $comment, $gcos, $dir, $shell, $expire) = getpwent()) {
        if ($uid == $newuid) {
            return 0;
        }
    }
    return 1;
}

#znajdujemy wolny UID
sub getUID {
    my $newuid = 100;
    while(uid_free($newuid) == 0) {
        $newuid = $newuid+1;
    }
    return $newuid;
}




























