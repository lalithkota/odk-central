CONFIG_PATH=${ENKETO_SRC_DIR}/config/config.json
echo "generating enketo configuration.."
/bin/bash -c "envsubst < ${CONFIG_PATH}.template > $CONFIG_PATH"

echo "starting pm2/enketo.."
pm2 start --no-daemon app.js -n enketo

