FROM alpine

# Setup dependencies
RUN apk --update add git mercurial bash php7-cli php7-curl php7-json

# Setup mercurial robustcheckout
RUN mkdir -p /usr/share/mercurial
RUN wget https://raw.githubusercontent.com/mozilla/version-control-tools/master/hgext/robustcheckout/__init__.py -O /usr/share/mercurial/robustcheckout.py
ADD hg.conf /root/.hgrc

# Setup arcanist
RUN mkdir -p /usr/share/php7
RUN git clone --depth=1 https://github.com/phacility/libphutil.git /usr/share/php7/libphutil
RUN git clone --depth=1 https://github.com/phacility/arcanist.git /usr/share/php7/arcanist
ENV PATH "$PATH:/usr/share/php7/arcanist/bin"

# Add crash tool
ADD crasher.sh /usr/bin/crasher

CMD /usr/bin/crasher
