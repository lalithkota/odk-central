FROM node:14.19.3

WORKDIR /usr/odk

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list; \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -; \
  apt-get update; \
  apt-get install -y cron gettext postgresql-client-14

COPY files/service/crontab /etc/cron.d/odk

COPY server/package*.json ./
RUN npm install --production
RUN npm install pm2 -g

COPY server/ ./
COPY files/service/scripts/ ./
COPY files/service/pm2.config.js ./

COPY files/service/config.json.template /usr/share/odk/
COPY files/service/odk-cmd /usr/bin/

ENV ENKETO_URL="enketo:8005"
ENV ENKETO_API_KEY="odk"
ENV DB_HOST="postgres"
ENV DB_PORT="5432"
ENV DB_NAME="odk"
ENV DB_USER="odk"
ENV DB_PASSWORD="odk"
ENV PYXFORM_HOST="pyxform"
ENV PYXFORM_PORT="80"
ENV SMTP_HOST="mail"
ENV SMTP_PORT="25"
ENV DOMAIN="localhost"
ENV HTTPS_PORT="443"
ENV SYSADMIN_EMAIL="admin@example.com"

EXPOSE 8383

