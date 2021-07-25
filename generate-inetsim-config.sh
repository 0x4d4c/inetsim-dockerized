#!/bin/bash
set -eu


CONFIG_FILE='/opt/inetsim/conf/inetsim.conf'
USER_CONFIG_FILES='/opt/inetsim/conf/user_configs'
DEFAULT_CONFIG_FILES='/opt/inetsim/conf/default_configs'


function write_config_value()
{
    if [ $# -eq 2 -a "$2" != "" ]; then
        echo "$1" "\"$2\"" >> $CONFIG_FILE
    fi
}


function write_config_values_from_file()
{
    if [ -f "$USER_CONFIG_FILES/$1" ]; then
        config_file="$USER_CONFIG_FILES/$1"
    else
        config_file="$DEFAULT_CONFIG_FILES/$1"
    fi
    cat $config_file >> $CONFIG_FILE
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
write_config_values_from_file dns_static_mappings
# Service HTTP
write_config_value http_bind_port "$INETSIM_HTTP_BIND_PORT"
write_config_value http_version "$INETSIM_HTTP_VERSION"
write_config_value http_fakemode "$INETSIM_HTTP_FAKEMODE"
write_config_values_from_file http_fakefiles
write_config_values_from_file http_static_fakefiles
# Service HTTPS
write_config_value https_bind_port "$INETSIM_HTTPS_BIND_PORT"
write_config_value https_version "$INETSIM_HTTPS_VERSION"
write_config_value https_fakemode "$INETSIM_HTTPS_FAKEMODE"
write_config_value https_ssl_keyfile "https_key.pem"
write_config_value https_ssl_certfile "https_cert.pem"
write_config_value https_ssl_dhfile "https_dhparams.pem"
write_config_values_from_file https_fakefiles
write_config_values_from_file https_static_fakefiles
# Service SMTP
write_config_value smtp_bind_port "$INETSIM_SMTP_BIND_PORT"
write_config_value smtp_fqdn_hostname "$INETSIM_SMTP_FQDN_HOSTNAME"
write_config_value smtp_banner "$INETSIM_SMTP_BANNER"
write_config_value smtp_helo_required "$INETSIM_SMTP_HELO_REQUIRED"
write_config_value smtp_extended_smtp "$INETSIM_SMTP_EXTENDED_SMTP"
write_config_value smtp_auth_reversibleonly "$INETSIM_SMTP_AUTH_REVERSIBLEONLY"
write_config_value smtp_auth_required "$INETSIM_SMTP_AUTH_REQUIRED"
write_config_value smtp_ssl_keyfile "smtp_key.pem"
write_config_value smtp_ssl_certfile "smtp_cert.pem"
write_config_value smtp_ssl_dhfile "smtp_dhparams.pem"
write_config_values_from_file smtp_service_extensions
# Service SMTPS
write_config_value smtps_bind_port "$INETSIM_SMTPS_BIND_PORT"
write_config_value smtps_fqdn_hostname "$INETSIM_SMTPS_FQDN_HOSTNAME"
write_config_value smtps_banner "$INETSIM_SMTPS_BANNER"
write_config_value smtps_helo_required "$INETSIM_SMTPS_HELO_REQUIRED"
write_config_value smtps_extended_smtp "$INETSIM_SMTPS_EXTENDED_SMTP"
write_config_value smtps_auth_reversibleonly "$INETSIM_SMTPS_AUTH_REVERSIBLEONLY"
write_config_value smtps_auth_required "$INETSIM_SMTPS_AUTH_REQUIRED"
write_config_value smtps_ssl_keyfile "smtps_key.pem"
write_config_value smtps_ssl_certfile "smtps_cert.pem"
write_config_value smtps_ssl_dhfile "smtps_dhparams.pem"
write_config_values_from_file smtps_service_extensions
# Service POP3
write_config_value pop3_bind_port "$INETSIM_POP3_BIND_PORT"
write_config_value pop3_banner "$INETSIM_POP3_BANNER"
write_config_value pop3_hostname "$INETSIM_POP3_HOSTNAME"
write_config_value pop3_mbox_maxmails "$INETSIM_POP3_MBOX_MAXMAILS"
write_config_value pop3_mbox_reread "$INETSIM_POP3_MBOX_REREAD"
write_config_value pop3_mbox_rebuild "$INETSIM_POP3_MBOX_REBUILD"
write_config_value pop3_enable_apop "$INETSIM_POP3_ENABLE_APOP"
write_config_value pop3_auth_reversibleonly "$INETSIM_POP3_AUTH_REVERSIBLEONLY"
write_config_value pop3_enable_capabilities "$INETSIM_POP3_ENABLE_CAPABILITIES"
write_config_value pop3_ssl_keyfile "pop3_key.pem"
write_config_value pop3_ssl_certfile "pop3_cert.pem"
write_config_value pop3_ssl_dhfile "pop3_dhparams.pem"
write_config_values_from_file pop3_capabilities
# Service POP3S
write_config_value pop3s_bind_port "$INETSIM_POP3S_BIND_PORT"
write_config_value pop3s_banner "$INETSIM_POP3S_BANNER"
write_config_value pop3s_hostname "$INETSIM_POP3S_HOSTNAME"
write_config_value pop3s_mbox_maxmails "$INETSIM_POP3S_MBOX_MAXMAILS"
write_config_value pop3s_mbox_reread "$INETSIM_POP3S_MBOX_REREAD"
write_config_value pop3s_mbox_rebuild "$INETSIM_POP3S_MBOX_REBUILD"
write_config_value pop3s_enable_apop "$INETSIM_POP3S_ENABLE_APOP"
write_config_value pop3s_auth_reversibleonly "$INETSIM_POP3S_AUTH_REVERSIBLEONLY"
write_config_value pop3s_enable_capabilities "$INETSIM_POP3S_ENABLE_CAPABILITIES"
write_config_value pop3s_ssl_keyfile "pop3s_key.pem"
write_config_value pop3s_ssl_certfile "pop3s_cert.pem"
write_config_value pop3s_ssl_dhfile "pop3s_dhparams.pem"
write_config_values_from_file pop3s_capabilities
# Service TFTP
write_config_value tftp_bind_port "$INETSIM_TFTP_BIND_PORT"
write_config_value tftp_allow_overwrite "$INETSIM_TFTP_ALLOW_OVERWRITE"
write_config_value tftp_enable_options "$INETSIM_TFTP_ENABLE_OPTIONS"
write_config_values_from_file tftp_options
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
write_config_value ftps_ssl_keyfile "ftps_key.pem"
write_config_value ftps_ssl_certfile "ftps_cert.pem"
write_config_value ftps_ssl_dhfile "ftps_dhparams.pem"
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
