

## Installing FFMPEG

FFMPEG is not available as a package and needs to be installed manually. The below example was taken from [https://hannes.enjoys.it/blog](https://hannes.enjoys.it/blog/2016/03/ffmpeg-on-raspbian-raspberry-pi/) and works out of the box on RPi model 3. But `ffmpeg` takes forever :) 

~~~~
# create a src folder in home for code
cd
mkdir src
cd src

# clone, build and install x264
git clone --depth 1 git://git.videolan.org/x264
cd x264
./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl
make -j 4
sudo make install

# clone, build and make ffmpeg
cd
cd src
git clone --depth=1 git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree
make -j4
sudo make install
~~~~

## Running bash script on boot in foreground

TODO

* https://alan-mushi.github.io/2014/10/26/execute-an-interactive-script-at-boot-with-systemd.html
* https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=165301
* https://raspberrypi.stackexchange.com/questions/15475/run-bash-script-on-startup
* https://superuser.com/questions/584931/howto-start-an-interactive-script-at-ubuntu-startup
* 