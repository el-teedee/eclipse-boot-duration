#!/bin/bash

# Script to extract duration of an Eclipse boot from logs
# cdate: 2018-09-15
# FIXME: does not handle runs from a day to next day!
# [] fixme: "parse log with 'starting by date'"

function getEclipseBootDuration() {
    local startSub=11 ; # where startSub is the offset (zero-based)
    local lengthSub=12 ; # and lengthSub is the length
    [[ -o xtrace ]] && local tracing=1 || local tracing=0 ;

	local file="$1" ;
	if [[ ! -f "$file" ]]; then
		echo "Error: \$1 must be eclipse log file" ;
		return 1 ;
	fi
    
    # Search for line with date
    local startBy="2018" ;
    [[ $tracing -eq 1 ]] && echo "# Extracting timestamps" ;
    start=$( cat $file | grep "$startBy" | head -n 1 ) ;
    end=$( cat $file | grep "$startBy" | tail -n 1 ) ;
    [[ $tracing -eq 1 ]] && echo "     start: $start" ;
    [[ $tracing -eq 1 ]] && echo "       end: $end" ;
    
    # convert date to millis
    # %s     seconds since 1970-01-01 00:00:00 UTC
    # %N     nanoseconds (000000000..999999999)
    [[ $tracing -eq 1 ]] && echo "# Convert date to millis: 1. remove suffix" ;
    sD=${start:${startSub}:${lengthSub}} ;
    eD=${end:${startSub}:${lengthSub}} ;
    [[ $tracing -eq 1 ]] && echo "     start (in): $sD" ;
    [[ $tracing -eq 1 ]] && echo "       end (in): $eD" ;

    [[ $tracing -eq 1 ]] && echo "# Convert date to millis: 2. get seconds" ;
    sS=$( date -d "$sD" +"%s" ) ;
    eS=$( date -d "$eD" +"%s" ) ;
    [[ $tracing -eq 1 ]] && echo "     start (out %s): $sS" ;
    [[ $tracing -eq 1 ]] && echo "       end (out %s): $eS" ;
    
    [[ $tracing -eq 1 ]] && echo "# Convert date to millis: 3. get nanos" ;
    sN=$( date -d "$sD" +"%N" ) ;
    eN=$( date -d "$eD" +"%N" ) ;
    [[ $tracing -eq 1 ]] && echo "     start (out %N): $sN" ;
    [[ $tracing -eq 1 ]] && echo "       end (out %N): $eN" ;

    [[ $tracing -eq 1 ]] && echo "# Convert date to millis: 4. get millis" ;
    sM=${sN:0:3} ;
    eM=${eN:0:3} ;
    [[ $tracing -eq 1 ]] && echo "     start (out %N -> millis): $sM" ;
    [[ $tracing -eq 1 ]] && echo "       end (out %N -> millis): $eM" ;

    [[ $tracing -eq 1 ]] && echo "# Compute duration" ;
    if [[ "$sS" -gt 1 ]] && [[ "$eS" -gt 1 ]]; then
        local startTime="${sS}${sM}";
        local endTime="${eS}${eM}";
        local duration="$( expr ${endTime} - ${startTime} )" ;
        
        [[ $tracing -eq 1 ]] && echo "     start: $startTime" ;
        [[ $tracing -eq 1 ]] && echo "     - end: $endTime" ;
        [[ $tracing -eq 1 ]] && echo "          = ${duration}" ;
    fi
    if [[ $tracing -eq 1 ]]; then
        echo "duration:" ;
        echo "${duration}ms" ;
        [[ "$duration" -gt 1000 ]] && echo -n "$( expr ${duration} / 1000 )s" ; echo ;
        [[ "$duration" -gt $( expr 60 * 1000 ) ]] && echo -n "$( expr ${duration} / $( expr 60 * 1000 ) )min" ; echo ;
    else
        # simply echo millis
        echo "$duration" ;
    fi
}

