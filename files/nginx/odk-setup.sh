echo "writing a new nginx configuration file.."
envsubst '\$ODK_CENTRAL_BACKEND_URL:\$ENKETO_URL' < /usr/share/nginx/odk.conf.template > /etc/nginx/conf.d/odk.conf

nginx -g "daemon off;"
