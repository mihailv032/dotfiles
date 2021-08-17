#!/bin/bash

STATE="`xset -q | grep 'Num Lock:    on'`"
if [ -z "$STATE" ]
then
	echo OFF
else
	echo ON
fi

#https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
