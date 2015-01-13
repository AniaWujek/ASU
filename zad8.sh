#!/bin/bash

plansza="0 0 0;0 0 0;0 0 0"
liczba_znakow=0

wykonaj_ruch()
{
    gracz=$1
    wiersz=$2
    kolumna=$3
    
    numer=`expr \( $wiersz - 1 \) \* 3 + $kolumna`    
    res=`czy_ruch_mozliwy $numer`
   

    if [ "$res" = "1" ]
        then
            plansza=`echo $plansza | sed "s/[0-2]/$gracz/$numer"`
            liczba_znakow=`expr $liczba_znakow + 1` 
      
    fi
    
}

wykonaj_ruch_komp()
{
    gracz=$1
    numer=$2
        
    res=`czy_ruch_mozliwy $numer`

    if [ "$res" = "1" ]
        then
            plansza=`echo $plansza | sed "s/[0-2]/$gracz/$numer"`
            liczba_znakow=`expr $liczba_znakow + 1`
            
        else
            echo "Nieprawidlowy ruch!"
    fi
    
}



czysc_plansze()
{
    plansza="0 0 0;0 0 0;0 0 0"
    liczba_znakow=0
}

czy_ruch_mozliwy()
{
    numer=$1
    znak=`jaki_znak $numer`
    if [ "$znak" != "0" ]
        then
            echo "0"
        else
            echo "1";
    fi
}

jaki_znak()
{
    znak=`echo $plansza | sed 's/;/ /g' | awk -v bb=$1 ' { print $bb } '`
    echo $znak
}

czy_wygrana()
{
    wygrana="0"
    for wiersz in 1 4 7
        do
            s=$wiersz
            z1=`jaki_znak $s`
            s=`expr $s + 1`
            z2=`jaki_znak $s`
            s=`expr $s + 1`
            z3=`jaki_znak $s`
            
            if [ "$z1" = "$z2" -a "$z1" = "$z3" -a "$z1" != "0" ]
                then
                    echo $z1
                    wygrana="1"
            fi
    done
    
    if [ "$wygrana" = "0" ]
        then
            
            for kolumna in 1 2 3
                do
                    
                    s=$kolumna
                    z1=`jaki_znak $s`
                    s=`expr $s + 3`
                    z2=`jaki_znak $s`
                    s=`expr $s + 3`
                    z3=`jaki_znak $s`
                    if [ "$z1" = "$z2" -a "$z1" = "$z3" -a "$z1" != "0" ]
                        then
                            echo $z1
                            wygrana="1"
                    fi
            done
    fi
    if [ "$wygrana" = "0" ]
        then
            
            z1=`jaki_znak 1`
            z2=`jaki_znak 5`
            z3=`jaki_znak 9`
            if [ "$z1" = "$z2" -a "$z1" = "$z3" -a "$z1" != "0" ]
                        then
                            echo $z1
                            wygrana="1"
            fi
    fi
    
    if [ "$wygrana" = "0" ]
        then
            
            z1=`jaki_znak 3`
            z2=`jaki_znak 5`
            z3=`jaki_znak 7`
            
            if [ "$z1" = "$z2" -a "$z1" = "$z3" -a "$z1" != "0" ]
                        then
                            echo $z1
                            wygrana="1"
            fi
    fi
    if [ "$wygrana" = "0" ]
        then
            echo "0"
    fi
    
    
}

czy_zapelniona()
{
    echo $plansza | awk ' !/0/ {full = 1;} {if (full == 1) print 1; else print 0;} '
}

wyswietl_plansze()
{
    echo
    echo $plansza | sed -e 's/ / | /g' -e 's/0/ /g' -e 's/1/x/g' -e 's/2/o/g' -e 's/;/\
--- --- ---\
 /g' -e 's/^/ /1'
    echo
}



ruch_komputera()
{
    if [ "$liczba_znakow" -eq "0" ]
        then
            echo "5"
            return
    fi
    #natychmiastowa wygrana
    test_wyg=`echo $plansza | awk '/0 . .;2 . .;2 . .|0 2 2;. . .;. . .|0 . .;. 2 .;. . 2/ {print "1"; seen=1}
                                    /. 0 .;. 2 .;. 2 .|2 0 2;. . .;. . ./ {if (seen!=1) print "2"; seen=1}
                                    /. . 0;. . 2;. . 2|2 2 0;. . .;. . ./ {if (seen!=1) print "3"; seen=1}
                                    /2 . .;0 . .;2 . .|. . .;0 2 2;. . ./ {if (seen!=1) print "4"; seen=1}
                                    /. 2 .;. 0 .;. 2 .|. . .;2 0 2;. . .|2 . .;. 0 .;. . 2/ {if (seen!=1) print "5"; seen=1}
                                    /. . 2;. . 0;. . 2|. . .;2 2 0;. . ./ {if (seen!=1) print "6"; seen=1}
                                    /2 . .;2 . .;0 . .|. . .;. . .;0 2 2/ {if (seen!=1) print "7"; seen=1}
                                    /. 2 .;. 2 .;. 0 .|. . .;. . .;2 0 2/ {if (seen!=1) print "8"; seen=1}
                                    /. . 2;. . 2;. . 0|. . .;. . .;2 2 0|2 . .;. 2 .;. . 0/ {if (seen!=1) print "9"; seen=1}'`
                                    
    if [ "$test_wyg" != "" ]
        then
            
            echo $test_wyg
            return
    fi
    
    #natychmiastowa przegrana
    test_przeg=`echo $plansza | awk '/0 . .;1 . .;1 . .|0 1 1;. . .;. . .|0 . .;. 1 .;. . 1/ {print "1"; seen=1}
                                    /. 0 .;. 1 .;. 1 .|1 0 1;. . .;. . ./ {if (seen!=1) print "2"; seen=1}
                                    /. . 0;. . 1;. . 1|1 1 0;. . .;. . ./ {if (seen!=1) print "3"; seen=1}
                                    /1 . .;0 . .;1 . .|. . .;0 1 1;. . ./ {if (seen!=1) print "4"; seen=1}
                                    /. 1 .;. 0 .;. 1 .|. . .;1 0 1;. . .|1 . .;. 0 .;. . 1/ {if (seen!=1) print "5"; seen=1}
                                    /. . 1;. . 0;. . 1|. . .;1 1 0;. . ./ {if (seen!=1) print "6"; seen=1}
                                    /1 . .;1 . .;0 . .|. . .;. . .;0 1 1/ {if (seen!=1) print "7"; seen=1}
                                    /. 1 .;. 1 .;. 0 .|. . .;. . .;1 0 1/ {if (seen!=1) print "8"; seen=1}
                                    /. . 1;. . 1;. . 0|. . .;. . .;1 1 0|1 . .;. 1 .;. . 0/ {if (seen!=1) print "9"; seen=1}'`
     if [ "$test_przeg" != "" ]
        then

            echo $test_przeg
            return
     fi
     
     #stawiamy obok naszego znaku
     for i in 1 2 3 4 5 6 7 8 9
        do
            znak=`jaki_znak $i`
            if [ "$znak" = "2" ]
                then
                    #mamy nasze pole, stawiamy obok jesli jest sens
                    #na srodku
                    if [ "$i" = "1" ]
                        then
                            z1=`jaki_znak 5`
                            z2=`jaki_znak 9`
                            if [ "$z1" = "0" -a "$z1" = "0" ]
                                then
                                    echo "5"

                                    return
                            fi
                    fi
                    
                    if [ "$i" = "3" ]
                        then
                            z1=`jaki_znak 5`
                            z2=`jaki_znak 7`
                            if [ "$z1" = "0" -a "$z1" = "0" ]
                                then
                                    echo "5"
                                
                                    return
                            fi
                    fi
                    
                    if [ "$i" = "7" ]
                        then
                            z1=`jaki_znak 5`
                            z2=`jaki_znak 3`
                            if [ "$z1" = "0" -a "$z1" = "0" ]
                                then
                                    echo "5"
                                   
                                    return
                            fi
                    fi
                    
                    if [ "$i" = "9" ]
                        then
                            z1=`jaki_znak 5`
                            z2=`jaki_znak 1`
                            if [ "$z1" = "0" -a "$z1" = "0" ]
                                then
                                    echo "5"
                                   
                                    return
                            fi
                    fi
                    
                    #w kolumnie
                    s1=`dodaj_kolumnami $i`
                    z1=`jaki_znak $s1`
                    s2=`dodaj_kolumnami $s1`
                    z2=`jaki_znak $s1`
                    if [ "$z1" = "0" -a "$z2" = "0" ]
                        then
                            echo $s1
                           
                            return
                    fi
                    
                    #w wierszu
                    s1=`dodaj_wierszami $i`
                    z1=`jaki_znak $s1`
                    s2=`dodaj_wierszami $s1`
                    z2=`jaki_znak $s2`
                    if [ "$z1" = "0" -a "$z2" = "0" ]
                        then
                            echo $s1
                          
                            return
                    fi
                    
            fi
        done
        
        #jesli nie znaleziono ruchu, srodek lub pierwsze wolne pole
        z=`jaki_znak 5`
        if [ "$z" = "0" ]
               then
                   echo "5"
                  
                   return
        fi
               
        for i in 1 2 3 4 5 6 7 8 9
            do
                z=`jaki_znak $i`
                if [ "$z" = "0" ]
                    then
                        
                        echo $i
                        return
                fi
        done
    
}

dodaj_kolumnami()
{
    a=$1

    c=`expr \( $a + 3 \)`
    if [ "$c" -gt "9" ]
        then
            c=`expr $c % 9`
    fi
    echo $c    
}

dodaj_wierszami()
{
    a=$1
    if [ "$a" = "1" -o "$a" = "4" -o "$a" = "7" -o "$a" = "2" -o "$a" = "5" -o "$a" = "8" ]  
        then
            c=`expr $a + 1`
            echo $c
            return
    fi
    
    if [ "$a" = "3" -o "$a" = "6" -o "$a" = "9" ]  
        then
            c=`expr $a - 2`
            echo $c
            return
    fi
      
}


echo "chcesz zagrac? (tak aby zagrac)"
read odp


while [ "$odp" = "tak" ]
    do
        echo "kto pierwszy?"
        read gracz

        while [ "$gracz" != "1" -a "$gracz" != "2" ]
            do
                echo "Ty - 1, komputer - 2"
                read gracz
            done  
        
        
        while [ "`czy_wygrana`" = "0" -a "`czy_zapelniona`" = "0" ]
            do
                
                wyswietl_plansze
               
                
                    
                
                if [ "$gracz" = "1" ]
                    then
                        echo "wiersz, kolumna: "
                        read wiersz kolumna
                        
                        while [ "$wiersz" != "1" -a "$wiersz" != "2" -a "$wiersz" != "3" ]
                            do
                                
                                echo "podaj numer wiersza od 1 do 3!"
                                read wiersz
                            done
                        while [ "$kolumna" != "1" -a "$kolumna" != "2" -a "$kolumna" != "3" ]
                            do
                                echo "podaj numer kolumny od 1 do 3!"
                                read kolumna
                            done
                            
                        liczba=$liczba_znakow

                        wykonaj_ruch $gracz $wiersz $kolumna
                        
                        while [ "$liczba_znakow" = "$liczba" ]
                            do
                                echo "Wybierz inne pole!"
                                
                                
                                
                                echo "wiersz, kolumna: "
                                read wiersz kolumna
                                while [ "$wiersz" != "1" -a "$wiersz" != "2" -a "$wiersz" != "3" ]
                                    do
                                        echo "podaj numer wiersza od 1 do 3!"
                                        read wiersz
                                    done
                                while [ "$kolumna" != "1" -a "$kolumna" != "2" -a "$kolumna" != "3" ]
                                    do
                                        echo "podaj numer kolumny od 1 do 3!"
                                        read kolumna
                                    done
                                    
                                liczba=$liczba_znakow

                                wykonaj_ruch $gracz $wiersz $kolumna  
                        done
                                
  
                        gracz="2"
                    else
                        
                        ruch=`ruch_komputera`
                       
                        wykonaj_ruch_komp $gracz $ruch
                        gracz="1"
                fi
                    
        done
        wyswietl_plansze
        if [ "`czy_zapelniona`" = "1" ]
            then
                echo "Remis!"
                echo
            else
                echo "Wygral gracz " `czy_wygrana`
                echo
        fi
        
        echo
        echo "jeszcze raz?"
        read odp
        czysc_plansze
        
done

echo $res

echo "KONIEC"
