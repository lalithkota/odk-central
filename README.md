ODK Central
===========

Central is the [ODK](https://getodk.org/) server. It manages user accounts and permissions, stores form definitions, and allows data collection clients like ODK Collect to connect to it for form download and submission upload.

Our goal with Central is to create a modern server that is easy to install, easy to use, and extensible with new features and functionality both directly in the software and with the use of our REST, OpenRosa, and OData programmatic APIs.

This repository serves as an umbrella for the Central project as a whole:

* Operations repository for packaging the server and client into a Docker Compose application.
* Release repository for publishing binary artifacts. Release notes can be found in this repository: see the [releases](https://github.com/getodk/central/releases).

If you are looking for help, please take a look at the [Documentation Website](https://docs.getodk.org/central-intro/). If that doesn't solve your problem, please head over to the [ODK Forum](https://forum.getodk.org) and do a search to see if anybody else has had the same problem. If you've identified a new problem or have a feature request, please post on the forum. We prefer forum posts to GitHub issues because more of the community is on the forum.

Changes compared to upstream
----------------------------
- Removed all TLS and certs creation by default.
- Pre built docker images.
- Available helm chart to install on kubernetes
- Other minor changes.

Impacts to installation:
- All TLS is left to outside the odk installation.
- Prepare SSL certs for TLS, before installation, on your own.
- Prepare the Domain name for installation.
- If using kubernetes, use ingress/loadbalancer for TLS.
- Or setup another nginx reverse proxy for TLS.

Installing on Kubernetes
------------------------

- Requires `kubectl` and `helm` utilities installed.
- Go to [helm](./helm) folder.
- Configure `values.yaml` according to the installation.
- Run
  ```sh
  ./install.sh
  ```
- Exec into the backend pod, and create user (and promote if required).
  ```sh
  kubectl exec -it <backend-pod> -- odk-cmd -u <email> user-create
  kubectl exec -it <backend-pod> -- odk-cmd -u <email> user-promote
  ```
- To uninstall, just delete the helm installation of odk-central. Example:
  ```sh
  helm -n odk delete odk-central
  ```

Installing using docker-compose
-------------------------------
- Copy paste `.env.template` to `.env`.
- Configure `.env` according to the installation.
- Use a command like the following, to generate variable length strings for these variables in `.env`, `ENKETO_SECRET`, `ENKETO_LESS_SECRET`, `ENKETO_API_KEY`.
  ```sh
  cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1
  ```
- Run
  ```sh
  docker-compose up -d
  ```
- Exec into the service docker to create user (and promote if required).
  ```sh
  docker-compose exec -it service -- odk-cmd -u <email> user-create
  docker-compose exec -it service -- odk-cmd -u <email> user-promote
  ```
- ODK Central can now be accessed at http://localhost:8333. Further setup an nginx with SSL, to proxy_pass into the above.
- To uninstall, run
  ```sh
  docker-compose down
  ```

Contributing
============

We would love your contributions to Central. If you have thoughts or suggestions, please share them with us on the [Features board](https://forum.getodk.org/c/features) on the ODK Forum. If you wish to contribute code, you have the option of working on the Backend server ([contribution guide](https://github.com/getodk/central-backend/blob/master/CONTRIBUTING.md)), the Frontend website ([contribution guide](https://github.com/getodk/central-frontend/blob/master/CONTRIBUTING.md)), or both. To set up a development environment, first follow the [Backend instructions](https://github.com/getodk/central-backend#setting-up-a-development-environment) and then optionally the [Frontend instructions](https://github.com/getodk/central-frontend#setting-up-your-development-environment).

In addition to the Backend and the Frontend, Central deploys services:

* Central relies on [pyxform-http](https://github.com/getodk/pyxform-http) for converting forms from XLSForm. It generally shouldn't be needed in development but can be run locally.
* Central relies on [Enketo](https://github.com/enketo/enketo-express) for web form functionality. Enketo can be run locally and configured to work with Frontend and Backend in development by following these [instructions](https://github.com/getodk/central-frontend/blob/master/docs/enketo.md).

Operations
==========

This repository serves administrative functions, but it also contains the Docker code for building and running a production Central stack.

To learn how to run such a stack in production, please take a look at [our DigitalOcean installation guide](https://docs.getodk.org/central-install-digital-ocean/).

License
=======

All of ODK Central is licensed under the [Apache 2.0](https://raw.githubusercontent.com/getodk/central/master/LICENSE) License.
