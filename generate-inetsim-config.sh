#!/bin/ash
set -eu


CONFIG_FILE='/opt/inetsim/conf/inetsim.conf'


function write_config_value()
{
    if [ $# -eq 2 -a "$2" != "" ]; then
        echo "$1" "\"$2\"" >> $CONFIG_FILE
    fi
}


inetsim_services='dns,http,smtp,pop3,tftp,ftp,ntp,time_tcp,time_udp,
                  daytime_tcp,daytime_udp,echo_tcp,echo_udp,discard_tcp,
                  discard_udp,quotd_tcp,quotd_udp,chargen_tcp,chargen_udp,
                  finger,ident,syslog,dummy_tcp,dummy_udp,smtps,pop3s,
                  ftps,irc,https'

INETSIM_START_SERVICES=${INETSIM_START_SERVICES:-$inetsim_services}

set +u
echo '# Auto-generated INetSim configuration file' > $CONFIG_FILE
for srv in ${INETSIM_START_SERVICES//,/ }; do
    write_config_value start_service $srv
done
write_config_value service_bind_address '0.0.0.0'
write_config_value service_run_as_user 'nobody'
write_config_value service_max_childs "$INETSIM_SERVICE_MAX_CHILDS"
write_config_value service_timeout "$INETSIM_SERVICE_TIMEOUT"
write_config_value create_reports "$INETSIM_CREATE_REPORTS"
write_config_value report_language "$INETSIM_REPORT_LANGUAGE"
# Faketime
write_config_value faketime_init_delta "$INETSIM_FAKETIME_INIT_DELTA"
write_config_value faketime_auto_delay "$INETSIM_FAKETIME_AUTO_DELAY"
write_config_value faketime_auto_increment "$INETSIM_FAKETIME_AUTO_INCREMENT"
# Service DNS
write_config_value dns_bind_port "$INETSIM_DNS_BIND_PORT"
write_config_value dns_default_ip "$INETSIM_DNS_DEFAULT_IP"
write_config_value dns_default_hostname "$INETSIM_DNS_DEFAULT_HOSTNAME"
write_config_value dns_default_domainname "$INETSIM_DNS_DEFAULT_DOMAINNAME"
write_config_value dns_version "$INETSIM_DNS_VERSION"

# Service HTTP
write_config_value http_bind_port "$INETSIM_HTTP_BIND_PORT"
write_config_value http_version "$INETSIM_HTTP_VERSION"
write_config_value http_fakemode "$INETSIM_HTTP_FAKEMODE"

# Service NTP
write_config_value ntp_bind_port "$INETSIM_NTP_BIND_PORT"
write_config_value ntp_server_ip "$INETSIM_NTP_SERVER_IP"
write_config_value ntp_strict_checks "$INETSIM_NTP_STRICT_CHECKS"
# Service IRC
write_config_value irc_bind_port "$INETSIM_IRC_BIND_PORT"
write_config_value irc_fqdn_hostname "$INETSIM_IRC_FQDN_HOSTNAME"
write_config_value irc_version "$INETSIM_IRC_VERSION"
# Service Time
write_config_value time_bind_port "$INETSIM_TIME_BIND_PORT"
# Service Daytime
write_config_value daytime_bind_port "$INETSIM_DAYTIME_BIND_PORT"
# Service Echo
write_config_value echo_bind_port "$INETSIM_ECHO_BIND_PORT"
# Service Discard
write_config_value discard_bind_port "$INETSIM_DISCARD_BIND_PORT"
