# Node docker image with latest stable chrome

[![Build Status](https://travis-ci.com/Romischart/node-chrome.svg?branch=master)](https://travis-ci.com/Romischart/node-chrome)

> Fully dockerized latest stable chrome based on [selenium/node-chrome](https://hub.docker.com/r/selenium/node-chrome) with nodejs & yarn preinstalled

## Why
This project enables you to use a real firefox for example for e2e testing (with tools like testcafe) directly in CI.

It could be used as base for your custom image.

**Global testcafe example:**
```dockerfile
FROM romischart/node-chrome:latest

RUN yarn global add testcafe \
    && mkdir -p /usr/src/app/testcafe

WORKDIR /usr/src/app/testcafe
```

and now you need to build the custom image and run the tests with docker volume mounting:
```bash
docker build -t testcafe-chrome .

docker run -v /path/to/tests:/usr/src/app/testcafe testcafe-chrome:latest testcafe chrome:headless -s *.testcafe.js
```

**Local testcafe example:**
```bash
docker run -it -v /path/to/tests:/home/node romischart/node-chrome:latest yarn testcafe chrome:headless
```

## Custom node version
You can build your own image with your custom node version, you need only to pass `NODE_VERSION` argument at build time:

```dockerfile
FROM romischart/node-chrome:latest
```

```bash
docker build . -t custom-node-version --build-arg NODE_VERSION=12.16.1
```