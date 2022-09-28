#!/usr/bin/env bash

NS=odk

cd charts/odk-backend; helm dependency update; cd ../..
cd charts/odk-frontend; helm dependency update; cd ../..
cd charts/odk-enketo; helm dependency update; cd ../..
cd charts/odk-mail; helm dependency update; cd ../..
cd charts/odk-pyxform; helm dependency update; cd ../..
helm dependency update

kubectl create ns $NS

kubectl -n $NS delete cm odk-central-enketo-redis --ignore-not-found
kubectl -n $NS create cm odk-central-enketo-redis \
    --from-file=../files/enketo/redis-enketo-main.conf \
    --from-file=../files/enketo/redis-enketo-cache.conf

helm -n $NS install odk-central . "$@"
