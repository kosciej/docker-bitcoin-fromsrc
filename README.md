# docker-bitcoin-fromsrc

This Dockerfile will create a Docker image with a bitcoind and cli. It compiles 
from source so it'll take some time to build. 

The configuration options are the default ones with GUI and uPnP disabled.

This allows you to compile exactly the sources you want and update quickly to new versions.

BTC donate address: 15nFeG58PKCG4RQQ5cDSZfH4dwdd3PSnKo

## Quick start

Requires that Docker be installed on the host machine:
- Ubuntu: `sudo apt-get install docker`
- otherwise: [docs](https://docs.docker.com/engine/installation/)

```
# Create some directory where your bitcoin data will be stored.
$ mkdir /home/youruser/bitcoin_data

$ docker run --name bitcoind -d \
   --env 'BTC_RPCUSER=foo' \
   --env 'BTC_RPCPASSWORD=password' \
   --volume /home/youruser/bitcoin_data:/bitcoin \
   --p 8332:8332
   --publish 8333:8333
   juanjux/bitcoind

$ docker logs -f bitcoind
```


## Configuration

A custom `bitcoin.conf` file can be placed in the mounted data directory.
Otherwise, a default `bitcoin.conf` file will be automatically generated based
on environment variables passed to the container:

| name | default |
| ---- | ------- |
| BTC_RPCUSER | btc |
| BTC_RPCPASSWORD | changemeplz |
| BTC_RPCPORT | 8332 |
| BTC_RPCALLOWIP | ::/0 |
| BTC_RPCCLIENTTIMEOUT | 30 |


## Daemonizing

If you're using systemd, you can use a config file like

```
$ cat /etc/systemd/system/bitcoind.service

# bitcoind.service #######################################################################
[Unit]
Description=Bitcoind
After=docker.service
Requires=docker.service
 
[Service]
ExecStartPre=-/usr/bin/docker kill bitcoind
ExecStartPre=-/usr/bin/docker rm bitcoind
ExecStartPre=/usr/bin/docker pull juanjux/bitcoind
ExecStart=/usr/bin/docker run \
    --name bitcoind \
    -p 8333:8333 \
    -p 8332:8332 \
    -v /data/bitcoind:/bitcoin \
    juanjux/bitcoind 
ExecStop=/usr/bin/docker stop bitcoind 
```

to ensure that bitcoind continues to run.


## Alternatives

- [docker-btc](https://github.com/jamesob/docker-btc) exactly the same, but using prebuild 
  Ubuntu images (used a a base for this repo).
- [docker-bitcoind](https://github.com/kylemanna/docker-bitcoind): sort of the
  basis for the parent repo, but configuration is a bit more confusing. 
- [docker-bitcoin](https://github.com/amacneil/docker-bitcoin): more complex, but 
  more granular versioning. Includes XT & classic.
