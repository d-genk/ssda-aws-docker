ADD file:c254898ceb4172f05cd40460f8d0b1ca2d39d5178bdddd4e794c7d3fc5a60a03 in /

CMD ["bash"]

EXPOSE map[8182/tcp:{}]

VOLUME [/imageroot]

RUN /bin/sh -c apt-get update -qy && apt-get dist-upgrade -qy && \
    apt-get install -qy --no-install-recommends curl imagemagick \
    libopenjp2-tools ffmpeg unzip default-jre-headless && \
    apt-get -qqy autoremove && apt-get -qqy autoclean

RUN /bin/sh -c adduser --system cantaloupe # buildkit

RUN /bin/sh -c curl --silent --fail -OL https://github.com/medusa-project/cantaloupe/releases/download/v$CANTALOUPE_VERSION/Cantaloupe-$CANTALOUPE_VERSION.zip \
    && unzip Cantaloupe-$CANTALOUPE_VERSION.zip \
    && ln -s cantaloupe-$CANTALOUPE_VERSION cantaloupe \
    && rm Cantaloupe-$CANTALOUPE_VERSION.zip \
    && mkdir -p /var/log/cantaloupe /var/cache/cantaloupe \
    && chown -R cantaloupe /cantaloupe /var/log/cantaloupe /var/cache/cantaloupe \
    && cp -rs /cantaloupe/deps/Linux-x86-64/* /usr/ # buildkit

ADD https://ssda-cantaloupe-configurationfile.s3.amazonaws.com/cantaloupe_settings.txt /cantaloupe/settings.txt # buildkit

RUN /bin/sh -c chown -R cantaloupe /cantaloupe/settings.txt # buildkit

USER cantaloupe

CMD ["sh" "-c" "java -Dcantaloupe.config=/cantaloupe/settings.txt -jar /cantaloupe/cantaloupe-$CANTALOUPE_VERSION.jar"]
