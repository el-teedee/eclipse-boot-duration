# eclipse-boot-duration

# Script to extract duration of an Eclipse boot from logs
# cdate: 2018-09-15
# FIXME: does not handle runs from a day to next day!

function getEclipseBootDuration() {
    # where startSub is the offset (zero-based)
    # and lengthSub is the length
    local startSub=11 ;
    local lengthSub=12 ;
    local logSep="\n-- " ;
    
    # Search for line with date
    # [] fixme: "starting by"
    local startBy="2018" ;
    [[ $tracing -eq 1 ]] && echo -e "${logSep}Extracting timestamps" ;
    start=$( cat $file | grep "$startBy" | head -n 1 ) ;
    end=$( cat $file | grep "$startBy" | tail -n 1 ) ;
    [[ $tracing -eq 1 ]] && echo "     start: $start" ;
    [[ $tracing -eq 1 ]] && echo "       end: $end" ;
    
    # Remove date prefix
    #[[ $tracing -eq 1 ]] && echo ">>> Remove date prefix" ;
    #start=${start/$( date "+%Y-%m-%d " )/} ;
    #end=${end/$( date "+%Y-%m-%d " )/} ;
    #[[ $tracing -eq 1 ]] && echo "     start: $start" ;
    #[[ $tracing -eq 1 ]] && echo "       end: $end" ;
    
    # Remove date suffix
    [[ $tracing -eq 1 ]] && echo -e "${logSep}Remove date suffix" ;
    sD=${start:${startSub}:${lengthSub}} ;
    eD=${end:${startSub}:${lengthSub}} ;
    [[ $tracing -eq 1 ]] && echo "     start: $eD" ;
    [[ $tracing -eq 1 ]] && echo "       end: $eD" ;
    
    # convert date to millis
    # %s     seconds since 1970-01-01 00:00:00 UTC
    # %N     nanoseconds (000000000..999999999)
    [[ $tracing -eq 1 ]] && echo -e "${logSep}Convert date to millis" ;
    [[ $tracing -eq 1 ]] && echo -e "     start (in): $sD" ;
    [[ $tracing -eq 1 ]] && echo -e "       end (in): $eD" ;

    [[ $tracing -eq 1 ]] && echo -e "${logSep}Convert date to millis: 1. get seconds" ;
    sS=$( date -d "$sD" +"%s" ) ;
    eS=$( date -d "$eD" +"%s" ) ;
    [[ $tracing -eq 1 ]] && echo "     start (out %s): $sS" ;
    [[ $tracing -eq 1 ]] && echo "       end (out %s): $eS" ;
    
    [[ $tracing -eq 1 ]] && echo -e "${logSep}Convert date to millis: 2. get nanos" ;
    sN=$( date -d "$sD" +"%N" ) ;
    eN=$( date -d "$eD" +"%N" ) ;
    [[ $tracing -eq 1 ]] && echo "     start (out %N): $sN" ;
    [[ $tracing -eq 1 ]] && echo "       end (out %N): $eN" ;

    [[ $tracing -eq 1 ]] && echo -e "${logSep}Convert date to millis: 3. get millis" ;
    sM=${sN:0:3} ;
    eM=${eN:0:3} ;
    [[ $tracing -eq 1 ]] && echo "     start (out %N -> millis): $sM" ;
    [[ $tracing -eq 1 ]] && echo "       end (out %N -> millis): $eM" ;

    #set -x ;
    [[ -o xtrace ]] && tracing=1 || tracing=0 ;
    [[ $tracing -eq 1 ]] && echo -e "${logSep}Compute duration\n" ;
    
    if [[ "$sS" -gt 1 ]] && [[ "$eS" -gt 1 ]]; then
        #local startTime="${sS}";
        #local endTime="${eS}";
        local startTime="${sS}${sM}";
        local endTime="${eS}${eM}";
        local duration="$( expr ${endTime} - ${startTime} )" ;
        
        [[ $tracing -eq 1 ]] && echo -e "  ${startTime}" ;
        [[ $tracing -eq 1 ]] && echo -e "- ${endTime}" ;
        [[ $tracing -eq 1 ]] && echo -e "= ${duration}" ;
    fi
    if [[ $tracing -eq 1 ]]; then
        echo "duration:" ;
        echo "${duration}ms" ;
        [[ "$duration" -gt 1000 ]] && echo -n "$( expr ${duration} / 1000 )s" ; echo ;
        [[ "$duration" -gt $( expr 60 * 1000 ) ]] && echo -n "$( expr ${duration} / $( expr 60 * 1000 ) )min" ; echo ;
    else
        echo "$duration" ;
    fi
}

# tracing: 1 if -x is set
set +x ;
set -x ;
[[ -o xtrace ]] && tracing=1 ;

#file=/tmp/$( date +"%s" )-eclipse.log ;
file=/tmp/eclipse.log ;
touch $file && rm $file ;

cat<<EOF>>$file
2018-09-15 20:00:00,200 Command started
BLA BLA BLA
2018-09-15 21:00:00,127 [Worker-9] BLA BLA BLA
2018-09-15 22:00:05,386 [Worker-9] INFO  
EOF
echo "$file: " ;
cat "$file" ;
getEclipseBootDuration "$file" ;
