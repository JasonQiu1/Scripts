#!/bin/bash

notesDir='/home/Jason/notes/'
fileExtension='.md'
today="$(date +%Y%m%d)"
date="$today"

fdate() {
    date=$(date -d "$1" +%Y%m%d)
}

addPath() {
    if [ "${1:0:1}" = "{" ]
    then
        # templated date
        if [ "${1:1:1}" != "}" ]
        then
            fdate "${1:1:$((${#1} - 2))} days ago"
        else
            date="$today"
        fi
        noteFile="$noteFile$date"
    else
        # regular text
        noteFile="$noteFile$1"
    fi
}

if [[ $# > 0 ]] 
then
    if [[ $# == 1 ]] && [[ $1 =~ ^[0-9]+|^-[0-9]+$ ]]
    then
        # assume number argument is notes from $1 days ago
        fdate "$1 days ago"
        noteFile="$notesDir"daily/"$date$fileExtension"
    else
        # if not just one number for daysAgo, then assume file path, where
        # last argument is file name
        noteFile="$notesDir"
        for path in ${@:1:$(($#-1))}
        do
            addPath "$path"
            noteFile="$noteFile"/
        done

        # make path if it doesn't exist
        if ! [[ -d "$noteFile" ]]
        then
            mkdir -p "$noteFile"
        fi

        # add the file name to the end
        addPath "${@: -1}"

        # add the default file extension if the filename did not include it
        if ! [[ "${@: -1}" =~ [a-zA-Z0-9]+\.[a-zA-Z0-9]+ ]]
        then
            noteFile="$noteFile$fileExtension"
        fi
    fi
else
    # default behavior, pull up today's note file
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
