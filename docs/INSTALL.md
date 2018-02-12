
# Installation and Configuration

Before you can start creating your first stop motion masterpiece, you need to install additional software and configure your RPi. 

## Raspberry Operating System (OS)

### Use NOOBS Jessie 2016

There are a number of operating systems to chose from on the [official RPi download page](https://www.raspberrypi.org/downloads/) on [www.raspberrypi.org](http://www.raspberrypi.org). We want to work with is the official distribution *Raspbian*. The easiest way to install *Raspbian* to your RPi is using the *NOOBS* distribution, which you can find on the download page linked above.

IMPORTANT: you need to use the jessie distribution which you can download here: [NOOBS Jessie 2016](http://downloads.raspberrypi.org/NOOBS/images/NOOBS-2016-10-05/NOOBS_v2_0_0.zip).

After you downloaded the `zip` file, all you need to do is `unzip` the archive, format a SD-card in `FAT32` and move the unzipped files to the SD-card. For more details, see the [official NOOBS installation page](https://www.raspberrypi.org/learning/software-guide/quickstart/).

### Installing Raspbian OS after booting your RPi

Before you boot your RPi for the first time, make sure that you have all the external devices plugged in. What we need at this stage:

1. An external monitor connected over HDMI
2. A WiFi card over USB (unless you are using a third generation RPi with an inbuilt WiFi card).
3. A keyboard and mouse over USB.

After the boot process has finished, you can select the operating system we want to work with: *Raspbian*. Select the checkbox and then hit **Install** above the selection.

### Configure your RPi

Now you have installed and operating system and even a windows manager (called Pixel on Raspbian). Start up your RPi and it will bring you straight to the home screen. Notice that you are not required to log in.

### Configure your keyboard

In the dropdown menu at the top of the home screen, select:

'Berry' > Preferences > Mouse and Keyboard Settings

Now select the tab *Keyboard* and then click *Keyboard Layout...* at the bottom right of the window. From the list, select your language layout.

### Configure the WiFi

At the top right of the home screen, in the top bar, you find an icon for *Wireless & Wired Network Settings*. Clicking on this icon will bring up a list of available WiFi networks. Select the one you want to connect with and set the password.

**Note**: Follow this link if you have [trouble with a USB Wifi card](https://www.raspberrypi.org/forums/viewtopic.php?t=44044).

**Disable WiFi power management**

Make sure the WiFi power management is disabled to avoid dropouts. [Follow these instructions](https://gist.github.com/mkb/40bf48bc401ffa0cc4d3#file-gistfile1-md).

### Access over SSH

SSH will allow you to log into the RPi from any machine in the network. This is useful because once the jukebox is up and running, it won't have a keyboard, mouse or monitor attached to it. Via SSH you can still configure the system and make changes - if you must.

Open a terminal to star the RPi configuration tool.

~~~~
sudo raspi-config
~~~~
Select `Interface Options` and then `SSH Enable/Disable remote command line...` to enable the remote access.

You should also change your password at this stage in `raspi-config`. The default password after a fresh install is `raspberry`. 

Find out more about how to [connect over SSH from Windows, Mac, Linux or Android on the official RPi page](https://www.raspberrypi.org/documentation/remote-access/ssh/).

### Autologin after boot

When you start the jukebox, it needs to fire up without stalling at the login screen. This can also be configured using the RPi config tool.

Open a terminal to star the RPi configuration tool.

~~~~
$ sudo raspi-config
~~~~

Select `Boot options` and then `Desktop / CLI`. The option you want to pick is `Console Autologin - Text console, automatically logged in as 'pi' user`.

### Set a static IP address for your RPi

**Note:** There are two ways to connect to your RPi Jukebox. In this document, the RPi will be part of your WiFi home network, connected to your router. Alternatively, you can [set up your RPi as a wireless access point](WLAN-ACCESS-POINT.md) and operate it without a router.

To be able to log into your RPi over SSH from any machine in the network, you need to give your machine a static IP address.

Check if the DHCP client daemon (DHCPCD) is active.
~~~~
sudo service dhcpcd status
~~~~
If you don't get any status, you should start the `dhcpcd` daemon:
~~~~
sudo service dhcpcd start
sudo systemctl enable dhcpcd
~~~~
Check the IP address the RPi is running on at the moment:
~~~~
$ ifconfig

wlan0     Link encap:Ethernet  HWaddr 74:da:38:28:72:72  
          inet addr:192.168.178.82  Bcast:192.168.178.255  Mask:255.255.255.0
          ...
~~~~
You can see that the IP address is 192.168.178.82. We want to assign a static address 192.168.178.200.

**Note:** assigning a static address can create conflict with other devices on the same network which might get the same address assigned. Therefore, if you can, check your router configuration and see if you can assign a range of IP addresses for static use.

Change the IPv4 configuration inside the file `/etc/dhcpcd.conf`.
~~~~
$ sudo nano /etc/dhcpcd.conf
~~~~
In my case, I added the following lines to assign the static IP. You need to adjust this to your network needs:

~~~~
interface wlan0
static ip_address=192.168.178.200/24
static routers=192.168.178.1
static domain_name_servers=192.168.178.1
~~~~
Save the changes with `Ctrl & O` then `Enter` then `Ctrl & X`.

## Installing Additional Software

### fswebcam - to take pictures

Fswebcam  is  a  [small and simple webcam app](http://manpages.ubuntu.com/manpages/xenial/man1/fswebcam.1.html). It can capture images  from  a  number  of  different  sources  and   perform   simple manipulation  on  the  captured image. The image can be saved as one or more PNG or JPEG files.

~~~~
sudo apt-get install fswebcam
~~~~

### avconv - creating videos from stills
You can stitch your JPEG images together using `avconv`, which needs to be installed. Creating a video from stills is slow on the RPi. You can copy the still images to your desktop / laptop and do it there, too.

On a Raspberry Pi 3, `avconv` can encode a little more than one frame per second. One second of a 15 frame per second video takes approx. 15 seconds.

Installing `avconv`:

~~~~
sudo apt-get install libav-tools
~~~~

### samba - to share folders over your home network

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
[pi_stopmotion]
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