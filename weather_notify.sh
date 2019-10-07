#!/bin/sh

#
# wether notify
#



#=================================================================#
# variable
#=================================================================#
WEATHER_URL='https://www.jma.go.jp/jp/week/348.html'
WEATHER_HTML='348.html'
TARGET='/tmp'

TOMMORROW=''
TWO_DAYS_AFTER=''
THREE_DAYS_AFTER=''
FOUR_DAYS_AFTER=''
FIVE_DAYS_AFTER=''
SIX_DAYS_AFTER=''
SEVEN_DAYS_AFTER=''


#=================================================================#
# functions
#=================================================================#

__getForecast(){

    rm ${TARGET}/${WEATHER_HTML} 2>/dev/null

    wget ${WEATHER_URL} -P  ${TARGET} 2>/dev/null

    TOMMORROW_ONE=`cat /tmp/348.html | grep pop | awk 'NR==1' | tr "<" " " | tr ">" " " | tr "/" " " | awk '{print $5}'`
    TOMMORROW_TWO=`cat /tmp/348.html | grep pop | awk 'NR==1' | tr "<" " " | tr ">" " " | tr "/" " " | awk '{print $6}'`
    TOMMORROW_THREE=`cat /tmp/348.html | grep pop | awk 'NR==1' | tr "<" " " | tr ">" " " | tr "/" " " | awk '{print $7}'`
    TOMMORROW_FOUR=`cat /tmp/348.html | grep pop | awk 'NR==1' | tr "<" " " | tr ">" " " | tr "/" " " | awk '{print $8}'`
    TWO_DAYS_AFTER=`cat /tmp/348.html | grep pop | awk 'NR==2' | tr "<" " " | tr ">" " " | awk '{print $5}'`
    THREE_DAYS_AFTER=`cat /tmp/348.html | grep pop | awk 'NR==3' | tr "<" " " | tr ">" " " | awk '{print $5}'`
    FOUR_DAYS_AFTER=`cat /tmp/348.html | grep pop | awk 'NR==4' | tr "<" " " | tr ">" " " | awk '{print $5}'`
    FIVE_DAYS_AFTER=`cat /tmp/348.html | grep pop | awk 'NR==5' | tr "<" " " | tr ">" " " | awk '{print $5}'`
    SIX_DAYS_AFTER=`cat /tmp/348.html | grep pop | awk 'NR==6' | tr "<" " " | tr ">" " " | awk '{print $5}'`
    SEVEN_DAYS_AFTER=`cat /tmp/348.html | grep pop | awk 'NR==7' | tr "<" " " | tr ">" " " | awk '{print $5}'`

    A=`echo $((100-$TOMMORROW_ONE)) | awk '{print $1*0.01}'`
    B=`echo $((100-$TOMMORROW_TWO)) | awk '{print $1*0.01}'`
    C=`echo $((100-$TOMMORROW_THREE)) | awk '{print $1*0.01}'`
    D=`echo $((100-$TOMMORROW_FOUR)) | awk '{print $1*0.01}'`
    E=`echo $A $B $C $D | awk '{print $1*$2*$3*$4}'`
    F=`echo $E | awk '{print 1-$1}'`
    G=`echo $F | awk '{print $1*100}'`
}

__weatherNotify(){
        curl -X POST -H "Authorization: Bearer XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" -F "message=明日の降水確率は$G%です" https://notify-api.line.me/api/notify
}


#=================================================================#
# main
#=================================================================#

__getForecast
__weatherNotify


exit 0
