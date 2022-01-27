#!/bin/bash

notesDir='/home/Jason/notes/'
fileExtension='.md'

if [[ $# > 0 ]] 
then
    if [[ $# == 1 ]] && [[ $1 =~ ^[0-9]+$ ]]
    then
        # assume number argument is notes from $1 days ago
        date=$(( $(date +%Y%m%d) - $1))
        noteFile="$notesDir"daily/"$date$fileExtension"
    else
        # if not just one number for daysAgo, then assume file path, where
        # last argument is file name
        noteFile="$notesDir"
        for path in ${@:1:$(($#-1))}
        do
            noteFile="$noteFile""$path"/
        done

        # make path if it doesn't exist
        if ! [[ -d "$noteFile" ]]
        then
            mkdir -p "$noteFile"
        fi

        if [[ "${@: -1}" =~ [a-zA-Z0-9]+\.[a-zA-Z0-9]+ ]]
        then
            noteFile="$noteFile${@: -1}"
        else
            noteFile="$noteFile${@: -1}$fileExtension"
        fi
    fi
else
    # default behavior, pull up today's note file
    date=$(date +%Y%m%d)
    noteFile="$notesDir"daily/"$date$fileExtension"
fi


#if being piped, then append stdout to noteFile
if (ls -l /proc/$$/fd/0 | grep -qv dev )
then
    touch "$noteFile"
    cat - >> "$noteFile"
    exit
fi

#if output being redirected, print notes 
if ( ls -l /proc/$$/fd/1 | grep -qv dev ) 
then
    cat "$noteFile"
    exit
fi

# if normal execution, then edit notefile 
$VISUAL "$noteFile"
