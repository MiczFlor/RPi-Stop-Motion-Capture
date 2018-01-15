

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