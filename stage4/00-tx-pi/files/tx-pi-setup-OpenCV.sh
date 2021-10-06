#!/bin/bash

# Install OpenCV
header "Install OpenCV"
if [ "$IS_STRETCH" = true ]; then
    apt-get -y install --no-install-recommends libatlas3-base libwebp6 libtiff5 libjasper1 libilmbase12 \
                                               libopenexr22 libilmbase12 libgstreamer1.0-0 \
                                               libavcodec57 libavformat57 libavutil55 libswscale4 \
                                               libgtk-3-0 libpangocairo-1.0-0 libpango-1.0-0 libatk1.0-0 \
                                               libcairo-gobject2 libcairo2 libgdk-pixbuf2.0-0
    pip3 install -U "opencv-python-headless>=3.0,<4.0.0"
else
    apt-get -y install --no-install-recommends python3-opencv
fi

apt-get -y install --no-install-recommends libzbar0 python3-pil libzbar-dev
pip3 install zbarlight

# system wide mpg123 overrides the included mpg123 of some apps
apt-get -y install --no-install-recommends mpg123
