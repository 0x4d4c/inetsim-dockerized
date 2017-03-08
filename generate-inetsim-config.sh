#!/bin/ash
set -eu

inetsim_services='dns,http,smtp,pop3,tftp,ftp,ntp,time_tcp,time_udp,
                  daytime_tcp,daytime_udp,echo_tcp,echo_udp,discard_tcp,
                  discard_udp,quotd_tcp,quotd_udp,chargen_tcp,chargen_udp,
                  finger,ident,syslog,dummy_tcp,dummy_udp,smtps,pop3s,
                  ftps,irc,https'

# Config parameters; consult official documentation for reference.
#
# The following parameters are modifiable via environment variables:
INETSIM_START_SERVICES="${INETSIM_START_SERVICES:-$inetsim_services}"
INETSIM_SERVICE_MAX_CHILDS="${INETSIM_SERVICE_MAX_CHILDS:-10}"
INETSIM_SERVICE_TIMEOUT="${INETSIM_SERVICE_TIMEOUT:-120}"
INETSIM_CREATE_REPORTS="${INETSIM_CREATE_REPORTS:-yes}"
INETSIM_REPORT_LANGUAGE="${INETSIM_REPORT_LANGUAGE:-en}"
# Faketime
INETSIM_FAKETIME_INIT_DELTA="${INETSIM_FAKETIME_INIT_DELTA:-0}"
INETSIM_FAKETIME_AUTO_DELAY="${INETSIM_FAKETIME_AUTO_DELAY:-0}"
INETSIM_FAKETIME_AUTO_INCREMENT="${INETSIM_FAKETIME_AUTO_INCREMENT:-3600}"
# Service DNS
INETSIM_DNS_BIND_PORT="${INETSIM_DNS_BIND_PORT:-53}"
INETSIM_DNS_DEFAULT_IP="${INETSIM_DNS_DEFAULT_IP:-127.0.0.1}"
INETSIM_DNS_VERSION="${INETSIM_DNS_VERSION:-INetSim DNS Server}"
INETSIM_DNS_DEFAULT_HOSTNAME="${INETSIM_DNS_DEFAULT_HOSTNAME:-www}"
INETSIM_DNS_DEFAULT_DOMAINNAME="${INETSIM_DNS_DEFAULT_DOMAINNAME:-inetsim.org}"
# Service HTTP
INETSIM_HTTP_BIND_PORT="${INETSIM_HTTP_BIND_PORT:-80}"
INETSIM_HTTP_VERSION="${INETSIM_HTTP_VERSION:-INetSim HTTP server}"
INETSIM_HTTP_FAKEMODE="${INETSIM_HTTP_FAKEMODE:-yes}"
# Service NTP
INETSIM_NTP_BIND_PORT="${INETSIM_NTP_BIND_PORT:-123}"
INETSIM_NTP_SERVER_IP="${INETSIM_NTP_SERVER_IP:-127.0.0.1}"
INETSIM_NTP_STRICT_CHECKS="${INETSIM_NTP_STRICT_CHECKS:-yes}"
# Service IRC
INETSIM_IRC_BIND_PORT="${INETSIM_IRC_BIND_PORT:-6667}"
INETSIM_IRC_FQDN_HOSTNAME="${INETSIM_IRC_FQDN_HOSTNAME:-irc.inetsim.org}"
INETSIM_IRC_VERSION="${INETSIM_IRC_VERSION:-INetSim IRC Server}"
# Service Time
INETSIM_TIME_BIND_PORT="${INETSIM_TIME_BIND_PORT:-37}"
# Service Daytime
INETSIM_DAYTIME_BIND_PORT="${INETSIM_DAYTIME_BIND_PORT:-13}"
# Service Echo
INETSIM_ECHO_BIND_PORT="${INETSIM_ECHO_BIND_PORT:-7}"
# Service Discard
INETSIM_DISCARD_BIND_PORT="${INETSIM_DISCARD_BIND_PORT:-9}"
#
# Config values not intended to be modified via environment variables:
INETSIM_SERVICE_BIND_ADDRESS='0.0.0.0'
INETSIM_SERVICE_RUN_AS_USER='nobody'


conf='/opt/inetsim/conf/inetsim.conf'

# Generate the config file.
echo '# Auto-generated INetSim configuration file' > $conf
for srv in ${INETSIM_START_SERVICES//,/ }; do
    echo "start_service $srv" >> $conf
done
echo "service_bind_address $INETSIM_SERVICE_BIND_ADDRESS" >> $conf
echo "service_run_as_user $INETSIM_SERVICE_RUN_AS_USER" >> $conf
echo "service_max_childs $INETSIM_SERVICE_MAX_CHILDS" >> $conf
echo "service_timeout $INETSIM_SERVICE_TIMEOUT" >> $conf
echo "create_reports $INETSIM_CREATE_REPORTS" >> $conf
echo "report_language $INETSIM_REPORT_LANGUAGE" >> $conf
echo "faketime_init_delta $INETSIM_FAKETIME_INIT_DELTA" >> $conf
echo "faketime_auto_delay $INETSIM_FAKETIME_AUTO_DELAY" >> $conf
echo "faketime_auto_increment $INETSIM_FAKETIME_AUTO_INCREMENT" >> $conf
echo "dns_bind_port $INETSIM_DNS_BIND_PORT" >> $conf
echo "dns_default_ip $INETSIM_DNS_DEFAULT_IP" >> $conf
echo "dns_default_hostname $INETSIM_DNS_DEFAULT_HOSTNAME" >> $conf
echo "dns_default_domainname $INETSIM_DNS_DEFAULT_DOMAINNAME" >> $conf
echo "dns_version $INETSIM_DNS_VERSION" >> $conf

echo "http_bind_port $INETSIM_HTTP_BIND_PORT" >> $conf
echo "http_version $INETSIM_HTTP_VERSION" >> $conf
echo "http_fakemode $INETSIM_HTTP_FAKEMODE" >> $conf

echo "ntp_bind_port $INETSIM_NTP_BIND_PORT" >> $conf
echo "ntp_server_ip $INETSIM_NTP_SERVER_IP" >> $conf
echo "ntp_strict_checks $INETSIM_NTP_STRICT_CHECKS" >> $conf
echo "irc_bind_port $INETSIM_IRC_BIND_PORT" >> $conf
echo "irc_fqdn_hostname $INETSIM_IRC_FQDN_HOSTNAME" >> $conf
echo "irc_version $INETSIM_IRC_VERSION" >> $conf
echo "time_bind_port $INETSIM_TIME_BIND_PORT" >> $conf
echo "daytime_bind_port $INETSIM_DAYTIME_BIND_PORT" >> $conf
echo "echo_bind_port $INETSIM_ECHO_BIND_PORT" >> $conf
echo "discard_bind_port $INETSIM_DISCARD_BIND_PORT" >> $conf
