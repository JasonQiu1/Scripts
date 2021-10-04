#!/bin/bash

# Get top post of each subscribed subbredit within one day
rootDir="/home/jason/scripts"
subbedSubsFile="$rootDir""/subscribedSubs.txt"
todaysFeedFile="$rootDir""/TodaysRedditFeed.txt"

> "$todaysFeedFile"
while read sub
do
    curl -sA "Mozilla 5.0 () ()" https://old.reddit.com/r/"$sub"/top.rss | stdbuf -oL grep -o "link href=\"[^\"]*\"" | cut -d \" -f 2 | head -n1 >> "$todaysFeedFile"
done < "$subbedSubsFile"

cat "$todaysFeedFile"
