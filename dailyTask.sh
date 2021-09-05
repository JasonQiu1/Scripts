#!/bin/bash

taskFile='./tasks.txt'
todaysTaskFile='./TodaysTask.txt'

# Edit if e or edit argument
if [[ $1 = "e" ]] || [[ $1 = "edit" ]] 
then
    $VISUAL "$taskFile"
    exit
else 
    if [[ $1 = "t" ]] 
    then
        map=(0,0,0,0,0,0,0,0,0,0)
        for i in {1..1000}
        do
            RANDOM=10#$(date +%s%N | cut -b10-17)
            rand=$(($RANDOM % 10))
            map[$rand]=$((${map[$rand]}+1))
        done
        echo ${map[*]}
        exit
    fi
fi

# Print cached task if already generated for today
if [ 10#$(find "$todaysTaskFile" -printf '%Cd' 2>/dev/null) == 10#$(date +%d) ] 
then
    echo $(cat "$todaysTaskFile")
    exit
fi

# Otherwise, generate a new task file
# Remove lines beginning with '#' and blank lines
tasks="$(awk '!/^$|^[[:space:]]*#/' "$taskFile")"
numLines=$(echo "$tasks" | wc -l)
# Seed a random number and pick a number less than numLines 
RANDOM=10#$(date +%s%N | cut -b10-17)
chosenTask=$(($RANDOM % $numLines))

i=0
IFS=$'\n'
for line in $tasks
do
    if [ $i == $chosenTask ]
    then
        # Print and cache
        echo "$line"
        echo "$line" > "$todaysTaskFile"
        break
    fi
    i=$(($i+1))
done
