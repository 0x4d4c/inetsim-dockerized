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
# Service HTTPS
#  TODO
# Service SMTP
#  TODO
# Service SMTPS
#  TODO
# Service POP3
#  TODO
# Service POP3S
#  TODO
# Service TFTP
#  TODO
# Service FTP
write_config_value ftp_bind_port "$INETSIM_FTP_BIND_PORT"
write_config_value ftp_version "$INETSIM_FTP_VERSION"
write_config_value ftp_banner "$INETSIM_FTP_BANNER"
write_config_value ftp_recursive_delete "$INETSIM_FTP_RECURSIVE_DELETE"
# Service FTPS
write_config_value ftps_bind_port "$INETSIM_FTPS_BIND_PORT"
write_config_value ftps_version "$INETSIM_FTPS_VERSION"
write_config_value ftps_banner "$INETSIM_FTPS_BANNER"
write_config_value ftps_recursive_delete "$INETSIM_FTPS_RECURSIVE_DELETE"
write_config_value ftps_ssl_keyfile "$INETSIM_FTPS_SSL_KEYFILE"
write_config_value ftps_ssl_certfile "$INETSIM_FTPS_SSL_CERTFILE"
write_config_value ftps_ssl_dhfile "$INETSIM_FTPS_SSL_DHFILE"
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
# Service Quotd
write_config_value quotd_bind_port "$INETSIM_QUOTD_BIND_PORT"
# Service Chargen
write_config_value chargen_bind_port "$INETSIM_CHARGEN_BIND_PORT"
# Service Finger
write_config_value finger_bind_port "$INETSIM_FINGER_BIND_PORT"
# Service Ident
write_config_value ident_bind_port "$INETSIM_IDENT_BIND_PORT"
# Service Syslog
write_config_value syslog_bind_port "$INETSIM_SYSLOG_BIND_PORT"
write_config_value syslog_trim_maxlength "$INETSIM_SYSLOG_TRIM_MAXLENGTH"
write_config_value syslog_accept_invalid "$INETSIM_SYSLOG_ACCEPT_INVALID"
# Service Dummy
write_config_value dummy_bind_port "$INETSIM_DUMMY_BIND_PORT"
write_config_value dummy_banner "$INETSIM_DUMMY_BANNER"
write_config_value dummy_banner_wait "$INETSIM_DUMMY_BANNER_WAIT"
