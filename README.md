# fastdbl

FFTDF fastd Blacklist

Geblockte Fastd Keys der Community Troisdorf

Repo in /etc/fastd/tro/fastdbl clonen

Installation:

1 - Cron:

    crontab -e

dort einfügen:

    */5 * * * * wget -q -O /etc/fastd/tro/fastdbl/fastd-blacklist.json https://raw.githubusercontent.com/Freifunk-Troisdorf/fastdbl/master/fastd-blacklist.json
    */5 * * * * /etc/fastd/tro/fastdbl/check_connections.sh

3 - Add the following to your fastd.conf:

	status socket "/var/run/fastd-status.sock";

    on verify "
      /etc/fastd/tro/fastbl/fastd-blacklist.sh $PEER_KEY
    ";

4 - Fastd Socket Status Script installieren:

    cp /etc/fastd/tro/fastdbl/fastd-query /usr/local/bin/fastd-query
    
