FROM node:14.19.3 as intermediate

COPY ./ ./
RUN files/prebuild/write-version.sh
RUN files/prebuild/build-frontend.sh

# make sure you have updated *.conf files when upgrading this
FROM nginx:1.23.1

EXPOSE 80

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        openssl \
        nginx-extras \
        netcat \
        lua-zlib \
    && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list

ENV ENKETO_URL='enketo:8005'
ENV ODK_CENTRAL_BACKEND_URL='service:8383'

COPY files/nginx/odk-setup.sh /scripts/

COPY files/nginx/default /etc/nginx/sites-enabled/
COPY files/nginx/inflate_body.lua /usr/share/nginx/
COPY files/nginx/odk.conf.template /usr/share/nginx/
COPY files/nginx/common-headers.nginx.conf /usr/share/nginx/
COPY --from=intermediate client/dist/ /usr/share/nginx/html/
COPY --from=intermediate /tmp/version.txt /usr/share/nginx/html/

RUN rm /etc/nginx/conf.d/default.conf

CMD [ "/bin/bash", "/scripts/odk-setup.sh" ]
