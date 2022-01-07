#!/bin/bash

process=$(pgrep steam)

if [ ! -z "$process" ] 
then
	steam -shutdown
fi

steam -login mrlayni 398722fd
