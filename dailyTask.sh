#!/bin/bash

taskFile=$HOME'/scripts/tasks.txt'
todaysTaskFile=$HOME'/scripts/TodaysTask.txt'
numTasks=1

# Edit if e or edit argument
if [[ $1 = "e" ]] || [[ $1 = "edit" ]] 
then
    $VISUAL "$taskFile"
    exit
else 
    # number of tasks to generate
    if [[ $1 =~ ^[0-9]+$ ]]
    then
        numTasks=$1
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
fi

# Print cached task if already generated for today and same number of tasks
if [ 10#$(find "$todaysTaskFile" -printf '%Cd' 2>/dev/null) == 10#$(date +%d) ] && [ $(cat "$todaysTaskFile" | wc -l) == $numTasks ]
then
    cat "$todaysTaskFile"
    exit
fi

# Otherwise, generate a new task file
# Remove lines beginning with '#' and blank lines
>| "$todaysTaskFile"
tasks="$(awk '!/^$|^[[:space:]]*#/' "$taskFile")"
numLines=$(echo "$tasks" | wc -l)

for numChosenTasks in $(seq 1 $numTasks)
do
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
            echo "$line" >> "$todaysTaskFile"
            break
        fi
        i=$(($i+1))
    done
done
