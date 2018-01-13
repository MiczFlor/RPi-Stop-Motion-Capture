#!/bin/bash

# packages needed:
# sudo apt-get install fswebcam ffmpeg

clear

# The absolute path to the folder whjch contains this script.
# Unless you are working with symlinks, leave the following line untouched.
PATHDATA="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# change into scripts directory to know where is what in relative paths
cd $PATHDATA

# If shared folder does not exist, create it
if [ ! -d ../shared ]; then
    mkdir ../shared
fi
# If no folder for VIDEOS exists, create it
if [ ! -d ../shared/VIDEOS ]; then
    mkdir ../shared/VIDEOS
fi
# If no folder for PROJECTS exists, create it
if [ ! -d ../shared/PROJECTS ]; then
    mkdir ../shared/PROJECTS
fi

# Looping infinitely and wait for keyboard input
while IFS= read -s -r -n1 char
do    
    # Clear the screen
    clear
    
    # Set the date and time of now
    NOW=`date +%Y%m%d-%H%M%S`
    
    # If no active project and project folder exist,
    # create them
    if [ ! -f ../shared/ProjectActive.txt ]; then
        # create the project folder
        mkdir ../shared/PROJECTS/$NOW
        # write project ID in ProjectActive.txt file
        echo $NOW > ../shared/ProjectActive.txt
    fi
    
    # Read active Project ID into variable
    PROJECTACTIVE=`cat ../shared/ProjectActive.txt`

    # If no folder for the active project ID exists, create it
    if [ ! -d ../shared/PROJECTS/$PROJECTACTIVE ]; then
        # create the project folder
        mkdir ../shared/PROJECTS/$PROJECTACTIVE
    fi
    
    # Print some info about the status for debugging
    echo Project ID: $PROJECTACTIVE
    if [ $char = "n" ]; then
        echo "Creating a new project"
        PROJECTACTIVE=`date +%Y%m%d-%H%M%S`
        # create the project folder
        mkdir ../shared/PROJECTS/$PROJECTACTIVE
        # write project ID in ProjectActive.txt file
        echo $PROJECTACTIVE > ../shared/ProjectActive.txt
    elif [ $char = "d" ]; then
        echo "Delete all frames of current project"
        rm ../shared/PROJECTS/$PROJECTACTIVE/*
    elif [ $char = "D" ]; then
        echo "Delete all frames AND current project"
        rm -rf ../shared/PROJECTS/$PROJECTACTIVE
        rm ../shared/ProjectActive.txt
    elif [ $char = "p" ]; then
        echo "Take picture"
        PICNAME=`date +%Y-%m-%d_%H-%M-%S-%N`
        fswebcam -r 1920x1080 --no-banner --save ../shared/PROJECTS/$PROJECTACTIVE/pic$PICNAME.jpg
    elif [ $char = "1" ]; then
        echo "Render video with 10 frames per second"
        cat ../shared/PROJECTS/$PROJECTACTIVE/*.jpg | ffmpeg -f image2pipe -r 10 -vcodec mjpeg -i - -vcodec libx264 ../shared/VIDEOS/$PROJECTACTIVE-10fps.mp4
    elif [ $char = "2" ]; then
        echo "Render video with 15 frames per second"
        cat ../shared/PROJECTS/$PROJECTACTIVE/*.jpg | ffmpeg -f image2pipe -r 15 -vcodec mjpeg -i - -vcodec libx264 ../shared/VIDEOS/$PROJECTACTIVE-15fps.mp4
    elif [ $char = "3" ]; then
        echo "Render video with 20 frames per second"
        cat ../shared/PROJECTS/$PROJECTACTIVE/*.jpg | ffmpeg -f image2pipe -r 20 -vcodec mjpeg -i - -vcodec libx264 ../shared/VIDEOS/$PROJECTACTIVE-20fps.mp4
    elif [ $char = "4" ]; then
        echo "Render video with 25 frames per second"
        cat ../shared/PROJECTS/$PROJECTACTIVE/*.jpg | ffmpeg -f image2pipe -r 25 -vcodec mjpeg -i - -vcodec libx264 ../shared/VIDEOS/$PROJECTACTIVE-25fps.mp4
    elif [ $char = "5" ]; then
        echo "Render video with 30 frames per second"
        cat ../sha
    else
        # display one character at a time
        echo  "$char"
    fi
    # Print some info about the status for debugging
    echo Project ID: $PROJECTACTIVE
done
