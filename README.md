# RDWV Docker Deployment

[![CircleCI](https://circleci.com/gh/rdwv/rdwv-docker.svg?style=svg)](https://circleci.com/gh/rdwv/rdwv-docker)
![Codecov](https://img.shields.io/codecov/c/github/rdwv/rdwv-docker?style=flat-square)

## Using provided scripts (easy)

To install RDWV, if you're on linux system(these scripts for windows will be added soon),
to download, set up, and run your RDWV instance, it is a matter of few commands:

```bash
sudo su -
git clone https://github.com/rdwv/rdwv-docker
cd rdwv-docker
# set needed environment variables, see below
./setup.sh
```

By default it will set up a systemd/upstart service to ensure your instance is running 24/7.
To configure your installation you can set different environment variables.

There are two types of environment variables: generator and app.
To understand how generator works, see [Architecture](#architecture).

Here is an example of the setup you will use in 90% cases. Replace `yourdomain.tld` with your actual domain (for rdwv demo, it was `rdwv.ai`):

```bash
sudo su -
git clone https://github.com/rdwv/rdwv-docker
cd rdwv-docker
export RDWV_HOST=yourdomain.tld
./setup.sh
```

This setup utilizes the [one domain mode](https://docs.rdwv.ai/guides/one-domain-mode). We recommend you to read about that.

**Important: for everything to work, you will need to first set up DNS A records for** `RDWV_HOST`**,** `RDWV_ADMIN_HOST` **(if set) and** `RDWV_STORE_HOST` **(if set) to point to the server where you are deploying RDWV.**

![DNS A records for rdwv demo](https://raw.githubusercontent.com/rdwv/rdwv-docs/master/.gitbook/assets/namecheap_dns_records.png)

_**Tip:**_ All the `_HOST` environment variables determine on which host (domain, without protocol) to run a service. All the `_URL` environment variables are to specify the URL (with protocol, http:// or https://) of the RDWV Merchants API to use.

_**Tip:**_ if you want to try out RDWV locally on your PC without a server, you can either enable [Tor support](https://docs.rdwv.ai/guides/tor) or use local deployment mode.

For that, replace `yourdomain.tld` with `rdwv.local` (or any domain ending in `.local`), and it will modify `/etc/hosts` for you, for it to work like a regular domain. If using local deployment mode, of course your instance will only be accessible from your PC.

If not using the [one domain mode](https://docs.rdwv.ai/guides/one-domain-mode), then you would probably run:

```bash
sudo su -
git clone https://github.com/rdwv/rdwv-docker
cd rdwv-docker
export RDWV_HOST=api.yourdomain.tld
export RDWV_ADMIN_HOST=admin.yourdomain.tld
export RDWV_STORE_HOST=store.yourdomain.tld
export RDWV_ADMIN_API_URL=https://api.yourdomain.tld
export RDWV_STORE_API_URL=https://api.yourdomain.tld
./setup.sh
```

Why was it done like so? It's because it is possible to run Merchants API on one server, and everything else on different servers.

But in most cases, you can basically do:

```bash
# if https (RDWV_REVERSEPROXY=nginx-https, default)
export RDWV_ADMIN_API_URL=https://$RDWV_HOST
export RDWV_STORE_API_URL=https://$RDWV_HOST
# if http (RDWV_REVERSEPROXY=nginx, local deployments, other)
export RDWV_ADMIN_API_URL=http://$RDWV_HOST
export RDWV_STORE_API_URL=http://$RDWV_HOST
```

## Configuration

Configuration settings are set like so:

    export VARIABLE_NAME=value

Here is a complete list of configuration settings:

| Name                          | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | Default     | Type      |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | --------- |
| RDWV_HOST                  | Host where to run RDWV Merchants API. Is used when merchants API (backend component) is enabled.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | :x:         | App       |
| RDWV_STORE_HOST            | Host where to run RDWV Ready Store. Is used when store component is enabled.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | :x:         | App       |
| RDWV_ADMIN_HOST            | Host where to run RDWV Admin Panel. Is used when admin component is enabled.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | :x:         | App       |
| RDWV_STORE_API_URL         | URL of RDWV Merchants API instance. It can be your instance hosted together with store or a completely separate instance. In case of default setup (store+admin+API at once), you need to set it to https://$RDWV_HOST or (http if nginx-https component is not enabled).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | :x:         | App       |
| RDWV_ADMIN_API_URL         | Same as RDWV_STORE_API_URL, but for configuring your admin panel.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | :x:         | App       |
| RDWV_LETSENCRYPT_EMAIL     | Email used for notifying you about your https certificates. Usually no action is needed to renew your certificates, but otherwise you'll get an email. Is used when nginx-https component is enabled.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | :x:         | App       |
| COINNAME_NETWORK              | Used for configuring network of COINNAME daemon. Daemon can be run in only one network at once. Possible values are mainnet, testnet, and sometimes regtest and simnet. This setting affects only daemon of COINNAME, you need to set this value for each coin daemon you want to customize.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | mainnet     | App       |
| COINNAME_LIGHTNING            | Used for enabling/disabling lightning support of COINNAME daemon. Some coins might not support lightning, in this case this setting does nothing. Possible values are true, false or not set. This setting affects only daemon of COINNAME, you need to set this value for each coin daemon you want to customize.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | false       | App       |
| RDWV_INSTALL               | Used for enabling different ready installation presets, instead of including certain components manually. Currently possible values are: all (enable backend and frontend component groups), backend (backend group only), frontend (frontend group only), none (no preset enabled, by default only enabled component in that case is btc daemon. It is used in custom setups where merchants features aren't needed, and only daemons are needed to be managed by docker stack). Component groups include a few components to ensure all pieces work. Backend group currently includes postgres, redis and merchants API. If only this group is enabled it can be used as API for deployments on a different server for example. Frontend group includes admin and store. They either use built-in merchants API or a custom hosted one. | all         | Generator |
| RDWV_CRYPTOS               | Used for configuring enabled crypto daemons. It is a comma-separated list of coin names, where each name is a coin code (for example btc, ltc). Each daemon component is enabled when it's respective coin code is in the list.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | btc         | Generator |
| RDWV_REVERSEPROXY          | Used for choosing reverse proxy in current docker-compose stack. Possible variants are: nginx-https(nginx+let's encrypt automatic ssl certificates), nginx(just nginx reverseproxy), none(no reverse proxy). Note that all HOST settings are applied only when nginx or nginx-https is enabled. When reverse proxy is none, few services expose their ports to the outside internet. By default they don't. List of those services: backend, admin, store and different coins if RDWV_COINAME_EXPOSE is true.                                                                                                                                                                                                                                                                                                                          | nginx-https | Generator |
| RDWV_ADDITIONAL_COMPONENTS | A space separated list of additional components to add to docker-compose stack. Enable custom integrations or your own developed components, making your app fit into one container stack. (allows communication between containers, using same db, redis, etc.)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | :x:         | Generator |
| RDWV_COINNAME_EXPOSE       | Used only when no reverse proxy is enabled. By default daemons aren't exposed to outside internet and are accessible only from inside container network (from other containers). Note that exposing daemon port to outside is a security risk, as potentially your daemon might be using default credentials that can be viewed from source code. Only do that if you know what you're doing! Merchants API exists for many reasons, and one of those is to protect daemons from direct access.                                                                                                                                                                                                                                                                                                                                           | :x:         | Generator |
| RDWV_COMPONENT_PORT        | Used when no reverse proxy is enabled. By default certain services are exposed to outside by their internal ports (3000 for store, 4000 for admin, 8000 for merchants API, 500X for daemons). Use that to override external container port. Here component is the internal component name. It can be found in generator/docker-components directory. For example for store it is store, for admin it is admin, for merchants API-backend, for bitcoin daemon-bitcoin. When unset, default port is used.                                                                                                                                                                                                                                                                                                                                   | :x:         | Generator |
| RDWV_COMPONENT_SCALE       | Scale component up to X processes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | 1           | Generator |
| TOR_RELAY_NICKNAME            | If tor relay is activated, the relay nickname                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | :x:         | Extension |
| TOR_RELAY_EMAIL               | If tor relay is activated, the email for Tor to contact you regarding your relay                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | :x:         | Extension |

## Live demo

We have live demo available at:

- [https://admin.rdwv.ai](https://admin.rdwv.ai/) RDWV Admin Panel
- [https://store.rdwv.ai](https://store.rdwv.ai/) RDWV Ready Store POS
- [https://api.rdwv.ai](https://api.rdwv.ai/) RDWV Merchants API

Note that it isn't designed for your production use, it is for testing and learning.

## Guide: how demo was set up

Basically via deployment steps above (:

Here are the commands used on our demo, as of July 2022, RDWV Version 0.6.7.8:

```bash
sudo su -
git clone https://github.com/rdwv/rdwv-docker
cd rdwv-docker
# host settings
export RDWV_HOST=api.rdwv.ai
export RDWV_ADMIN_HOST=admin.rdwv.ai
export RDWV_STORE_HOST=store.rdwv.ai
export RDWV_ADMIN_API_URL=https://api.rdwv.ai
export RDWV_STORE_API_URL=https://api.rdwv.ai
# reverse proxy settings, we use none because we configure nginx manually
export RDWV_REVERSEPROXY=none
# cryptocurrency settings
# we enable all currencies we support on the demo to test that they work
export RDWV_CRYPTOS=btc,bch,ltc,bsty,xrg,eth,bnb,sbch,matic,trx,grs,xmr
# lightning network for supported coins
export BTC_LIGHTNING=true
export LTC_LIGHTNING=true
export BSTY_LIGHTNING=true
export GRS_LIGHTNING=true
# tor support
export RDWV_ADDITIONAL_COMPONENTS=tor
./setup.sh
```

## Development builds

Currently the testing of individual pieces of RDWV is done via local development installation, see [Manual Deployment](https://docs.rdwv.ai/deployment/manual) about how it is done.

When doing some changes in generator, it is usually tested via local python installation, like so:

```bash
pip3 install oyaml
make generate
cat compose/generated.yml # see the generated output
```

If it is needed to test generator in docker, then run those commands:

```bash
export RDWVGEN_DOCKER_IMAGE=rdwv/docker-compose-generator:local
./build.sh # now uses local image
```

## Architecture

To provide a variety of deployment methods, to fit in every possible use case, we use a custom generator system.
All the services are run by docker-compose.
It makes it possible for containers to communicate between each other without exposing sensitive APIs to outside network.

Usually, to launch docker-compose cluster a docker-compose.yml is required.

In our case it is not present, as it is generated dynamically.

When running generator manually, or as a part of easy deployment, generator is called (either dockerized or via local python).

It runs a simple python script, it's purpose is to generated docker compose configuration file based on environment variables set.

See [Configuration](#configuration) section above about how different configuration settings affect the choice of components.

After getting a list of components to load, generator tries to load each of the components.
It loads components from `generator/docker-components` directory. Each component is a piece of complete docker-compose.yml file,
having service it provides, and any additional changes to other components.

If no service with that name is found, it is just skipped.

Each component might have services (containers), networks and volumes (for storing persistent data).

All that data is collected from each component, and then all the services list is merged (it is done to make configuring one component from another one possible).

After merging data into complete setup, generator applies a set of rules on them.
Rules are python scripts, which can dynamically change some settings of components based on configuration settings or enabled components.

Rules are loaded from `generator/rules` directory. Each rule is a python file.
Each python file (.py) must define `rule` function, accepting two parameters - `services` (dictionary of all services loaded) and `settings` (loaded from env variables).

If such function exists, it will be called with current services dictionary.
Rules can modify that based on different settings.
There are a few default settings bundled with RDWV (for example, to expose ports to outside when no reverse proxy is enabled).
You can create your own rules to add completely custom settings for your deployment.
Your RDWV deployment is not only RDWV itself, but also a powerful and highly customizable docker-compose stack generator.

After applying rules, the resulting data is written to compose/generated.yml file, which is final docker-compose.yml file used by startup scripts.
