docker-no-ip
============

This docker image is based off coppit/no-ip. It has been adapted for arm64 with the intention of running on a Raspberry Pi 4B kubernetes cluster.

This is a simple Docker container for running the [No-IP2](http://www.noip.com/) dynamic DNS update script. It will keep
your domain.ddns.net DNS alias up-to-date as your home IP changes.

Usage
-----


There are two modes of running this container. The first is with environment variables:

`sudo docker run --name=noip -d -v /etc/localtime:/etc/localtime -v /config/dir/path:/config -e USERNAME=<username> -e PASSWORD=<password> -e DOMAINS=<domains> -e INTERVAL=<interval> funwithkubes/rasp-noip:1.0`

The second mode is with a config file. To create a template config file, run:

`sudo docker run --name=noip -d -v /etc/localtime:/etc/localtime -v /config/dir/path:/config funwithkubes/rasp-noip:1.0`

When run for the first time, a file named noip.conf will be created in the config dir, and the container will exit. Edit
this file, adding your username (email), password, domains, and update interval. Then rerun the command to start the
container.

In both modes, a binary config file /config/dir/path/no-ip2.generated.conf will be generated. Please do not edit this
file, as it is used by the noip2 agent. 

To check the status, run `docker logs noip`.
