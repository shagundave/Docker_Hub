FROM node:12.14

# Google Chrome

RUN apt-get update && \
    apt-get install -y gnupg wget curl unzip --no-install-recommends && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update -y && \
    apt-get install -y google-chrome-stable && \
    CHROMEVER=$(google-chrome --product-version | grep -o "[^\.]*\.[^\.]*\.[^\.]*") && \
    DRIVERVER=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROMEVER") && \
    wget -q --continue -P /chromedriver "http://chromedriver.storage.googleapis.com/$DRIVERVER/chromedriver_linux64.zip" && \
    unzip /chromedriver/chromedriver* -d /chromedriver

#RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#	&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
#	&& apt-get update -qqy \
#	&& apt-get -qqy install google-chrome-stable \
#	&& rm /etc/apt/sources.list.d/google-chrome.list \
#	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
#	&& sed -i 's/"$HERE\/chrome"/"$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome

# ChromeDriver

#ARG CHROME_DRIVER_VERSION=2.31
#RUN wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
#	&& rm -rf /opt/chromedriver \
#  && apt-get update -qqy \
#  && apt-get install zip -y \
#	&& unzip /tmp/chromedriver_linux64.zip -d /opt \
#	&& rm /tmp/chromedriver_linux64.zip \
#	&& mv /opt/chromedriver /opt/chromedriver-$CHROME_DRIVER_VERSION \
#	&& chmod 755 /opt/chromedriver-$CHROME_DRIVER_VERSION \
#	&& ln -fs /opt/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver

# Xvfb

#RUN apt-get update -qqy \
#	&& apt-get -qqy install xvfb \
#&& rm -rf /var/lib/apt/lists/* /var/cache/apt/*
