
# Installation

Before you can start creating your first stop motion masterpiece, you need to install additional software and configure your RPi. 

## fswebcam - to take pictures

Fswebcam  is  a  [small and simple webcam app](http://manpages.ubuntu.com/manpages/xenial/man1/fswebcam.1.html). It can capture images  from  a  number  of  different  sources  and   perform   simple manipulation  on  the  captured image. The image can be saved as one or more PNG or JPEG files.

~~~~
sudo apt-get install fswebcam
~~~~

## avconv - creating videos from stills
You can stitch your JPEG images together using `avconv`, which needs to be installed. Creating a video from stills is slow on the RPi. You can copy the still images to your desktop / laptop and do it there, too.

On a Raspberry Pi 3, `avconv` can encode a little more than one frame per second. One second of a 15 frame per second video takes approx. 15 seconds.

Installing `avconv`:

~~~~
sudo apt-get install libav-tools
~~~~

## samba - to share folders over your home network

The way to integrate your RPi into your home network is using *Samba*, the standard [Windows interoperability suite for Linux and Unix](https://www.samba.org/).

Open a terminal and install the required packages with this line:

~~~~
$ sudo apt-get install samba samba-common-bin 
~~~~

First, let's edit the *Samba* configuration file and define the workgroup the RPi should be part of.

~~~~
$ sudo nano /etc/samba/smb.conf
~~~~

Edit the entries for workgroup and wins support:

~~~~
workgroup = WORKGROUP
wins support = yes
~~~~

If you are already running a windows home network, add the name of the network where I have added `WORKGROUP`. 

Now add the specific folder that we want to be exposed to the home network in the `smb.conf` file. 

~~~~
[pi_jukebox]
   comment= Pi Stop Motion
   path=/home/pi/RPi-Stop-Motion-Capture/shared
   browseable=Yes
   writeable=Yes
   only guest=no
   create mask=0777
   directory mask=0777
   public=no
~~~~

**Note:** the `path` given in this example works (only) if you are installing the jukebox code in the directory `/home/pi/`.

Finally, add the user `pi` to *Samba*. For simplicity and against better knowledge regarding security, I suggest to stick to the default user and password:

~~~~
user     : pi
password : raspberry
~~~~

Type the following to add the new user:

~~~~
$ sudo smbpasswd -a pi
~~~~



## Running bash script on boot in foreground

TODO

* https://alan-mushi.github.io/2014/10/26/execute-an-interactive-script-at-boot-with-systemd.html
* https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=165301
* https://raspberrypi.stackexchange.com/questions/15475/run-bash-script-on-startup
* https://superuser.com/questions/584931/howto-start-an-interactive-script-at-ubuntu-startup
* 