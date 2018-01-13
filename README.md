# RPi-Stop-Motion-Capture
Stop motion video capture with the Raspberry Pi using a standard USB webcam.

The script will create a `shared` folder containing the folders `VIDEOS` and `PROJECTS` 
if no such folders exist. The project folders are named like a time stamp in the order of
YearMonthDay-HourMinuteSecond.

The key "p" will take pictures with a time stamp in the current project folder.

Pressing the numbers 1 to 5 will render MP4 movies of the individual frames in the
VIDEOS folder.

## Controls

The list shows the key commands and what they do

* "p" Take picture
* "n" Creating a new project
* "d" Delete all frames of current project
* "D" Delete all frames AND current project
* "1" Render video with 10 frames per second
* "2" Render video with 15 frames per second
* "3" Render video with 20 frames per second
* "4" Render video with 25 frames per second
* "5" Render video with 30 frames per second

## Usage

Clone the git repo, install the required packages, run shell script.

````
cd
sudo apt-get install git fswebcam ffmpeg
git clone https://github.com/MiczFlor/RPi-Stop-Motion-Capture.git
cd RPi-Stop-Motion-Capture/scripts/
chmod +x stopmotion.sh
./stopmotion.sh
````

Stop the script with `Ctrl & C`