# docker-virtualradarserver
Dockerized version of [VirtualRadarServer](https://www.virtualradarserver.co.uk/) for Linux.

Current and latest release is on the `:dev` branch. Latest stable releases are at `v3pX` branches - according to the availabe pre-releases of VRS.

### Requirements
This container expects data input via network from a running instance of e.g. [readsb-protobuf](https://github.com/sdr-enthusiasts/docker-readsb-protobuf), [readsb bare-metal](https://github.com/wiedehopf/readsb) or [tar1090](https://github.com/sdr-enthusiasts/docker-tar1090) (as long it's attached to your SDR). Any other data sources _should_ work, as long tehy offer one of the [supported formats](https://www.virtualradarserver.co.uk/Documentation/WebServer/ReceiversOptions.aspx)

It'll run on a Rpi, recommended is a Rpi4 with at least 2GB RAM. As VRS is a bit of ressource hog, your results will depend very much on the amount of planes your receiver picks up (or you get from some other source).

### example docker-compose.yml
```
version: '3.8'

services:

  vrs:
    image: rhodan76/vrs:dev
    tty: true
    container_name: vrs
    hostname: vrs
    restart: always
    ports:
        - 8085:8080
    environment:
        - VRS_ADMIN_USERNAME=your_webadmin_user
        - VRS_ADMIN_PASSWORD=your_webadmin_pass
        - VRS_CULTURE=de-DE
        #see http://msdn.microsoft.com/en-us/goglobal/bb896001.aspx for a list of supported culture names. Not all translations may be available
    tmpfs:
        - /tmp:rw,nosuid,nodev,noexec,relatime,size=128M
    volumes:
        - /opt/adsb/vrs:/root/.local/share/VirtualRadar
        - "/etc/localtime:/etc/localtime:ro"
        - "/etc/timezone:/etc/timezone:ro"
```
The final configuration is done via the VRS Web Admin Interface, which can be found at `http://<HOST_IP:8085/VirtualRadar/WebAdmin/Index.html`
After startup, VRS will point to `readsb` as it's first and only receiver - which will work out of the box if the container is in the same stack as `readsb`, which is the case if you followed [this guide](https://sdr-enthusiasts.gitbook.io/ads-b/).

On first startup the container downloads [some additional files](https://github.com/rikgale/VRSOperatorFlags), namely a pre-populated BaseStation.sqb, a [LocalAircraft.txt](https://github.com/rikgale/LocalAircraft) which corrects some incorrect flagged aircrafts and some nice custom Operator Flags and Silhouettes made by [rikgale](https://github.com/rikgale) and the group effort of [the community](https://discord.com/channels/734090820684349521/797799467880677377)
Everything ist constantly updated and help is much appreciated. Any requests can be filed through the [issues](https://github.com/rikgale/VRSOperatorFlags/issues).

Subsequent updates of the files occur on a container-restart. Additionally, the originating repository is checked every 6 hours for updates. New files will be downloaded automatically.

Requests for the LocalAircraft.txt go [here](https://github.com/rikgale/LocalAircraft/issues)

### Scope of supply
The container image comes with the following preinstalled VRS V3 [plugins](https://www.virtualradarserver.co.uk/Download.aspx#panel-web-admin):
* Language Pack
* Custom Content
* Database Editor
* Database Writer
* Feed Filter
* SQL Server
* Tile Server Cache
* Web Admin

(batteries are not included)

### Something does not work, is broken or missing
Well, that happens. Drop by our [Discord](https://discord.com/channels/734090820684349521/797799467880677377) and we'll see what we can do.
