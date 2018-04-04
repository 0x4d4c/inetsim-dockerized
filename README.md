# inetsim-dockerized
Dockerfile and scripts to build a [Docker](https://www.docker.com/) image for [INetSim](http://www.inetsim.org/).

# Quickstart
To start INetSim with DNS, HTTP, HTTPS, and FTP enabled run:
```
$ docker run -it --rm --name inetsim \
      -p 127.0.0.1:53:53/udp \
      -p 127.0.0.1:80:80 \
      -p 127.0.0.1:443:443 \
      -p 127.0.0.1:21:21 \
      -e INETSIM_START_SERVICES=dns,http,https,ftp \
      -e INETSIM_DNS_VERSION="DNS Version" \
      -e INETSIM_FTPS_BIND_PORT=21 \
      -v $(pwd)/user_configs:/opt/inetsim/conf/user_configs:ro \
      0x4d4c/inetsim
```

# Volumes
The following directories are defined as volumes:

| Directory | Purpose |
| --- | --- |
| `/opt/inetsim/conf/user_configs` | Place for files to override default config files. |
| `/opt/inetsim/data` | Service data directory. |
| `/opt/inetsim/log` | INetSim log files. |
| `/opt/inetsim/report` | INetSim report files. |

# Configuration
Most of the configuration is done via environment variables. Since there are quite some options which can be set I suggest using an environment file (via `--env-file`) or a `docker-compose.yml`.

## Global
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_START_SERVICES` | Commna separated list of services to start. |  `dns,http,https,ftp` | 
| `INETSIM_SERVICE_MAX_CHILDS` | Maximum number of child processes (parallel connections) for each service. | `10` |
| `INETSIM_SERVICE_TIMEOUT` | If a client does not send any data for the number of seconds given here, the corresponding connection will be closed. | `120` |
| `INETSIM_CREATE_REPORTS` | Create report with a summary of connections for the session on shutdown. | `yes` or `no` |
| `INETSIM_REPORT_LANGUAGE` | Set language for reports. Refer to the INetSim docs for a list of supported languages. | `en` |
| `INETSIM_FAKETIME_INIT_DELTA` | Initial number of seconds (positive or negative) relative to current date/time for fake time used by all services. | `0` |
| `INETSIM_FAKETIME_AUTO_DELAY` | Number of seconds to wait before incrementing fake time by value specified with `INETSIM_FAKETIME_AUTO_INCREMENT` (`0` disables this option). | `0` |
| `INETSIM_FAKETIME_AUTO_INCREMENT` | Number of seconds by which fake time is incremented at regular intervals specified by `INETSIM_FAKETIME_AUTO_DELAY`. This option only takes effect if `INETSIM_FAKETIME_AUTO_DELAY` not set to `0`. | `0` |

## SSL/TLS Files
Some services use of TLS connections. All TLS related files (certificates, keys, DH parameters) have to be stored under `/opt/inetsim/data/certs/`. If this directory is empty, the [entrypoint script(docker-entrypoint.sh) will generate a private key, a self-signed certificate, and a DH parameters file. These will be used by all activated services, which use TLS. If you want to use your own files, simply put them into `/opt/inetsim/data/certs/`, e.g. by mounting a volume.

The following table lists which services uses which files:
| Service | Certificate | Key | DH parameters |
| --- | --- | --- | --- |
HTTPS | https_cert.pem | https_key.pem | https_dhparams.pem |
SMTP | smtp_cert.pem | smtp_key.pem | smtp_dhparams.pem |
SMTPS | smtps_cert.pem | smtps_key.pem | smtps_dhparams.pem |
POP3 | pop3_cert.pem | pop3_key.pem | pop3_dhparams.pem |
POP3s | pop3s_cert.pem | pop3s_key.pem | pop3s_dhparams.pem |
FTPS | ftps_cert.pem | ftps_key.pem | ftps_dhparams.pem |

If you don't provide your own files for a service, it will use the default certificate (`default_cert.pem`), default key (`default_key.pem`), and default DH parameters (`default_dhparams.pem`).

## Services
### DNS
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_DNS_BIND_PORT` | Port number to bind DNS service to. | `53` |
| `INETSIM_DNS_DEFAULT_IP` | Default IP address to return with DNS replies. | `10.10.10.1`
| `INETSIM_DNS_DEFAULT_HOSTNAME` | Default hostname to return with DNS replies. | `somehost` |
| `INETSIM_DNS_VERSION` | DNS version to return. | `"INetSim DNS Server"` |
| `INETSIM_DNS_DEFAULT_DOMAINNAME` | Default domain name to return with DNS replies. | `some.domain` |

#### Static DNS Mappings
INetSim allows you to define static domain ↔ IP mappings. These mappings can be used to make the DNS service respond with the defined IPs when the corresponding domains are queried and vice versa. There are no predefined static mappings. That is, the services uses the values of `INETSIM_DNS_DEFAULT_IP` and `INETSIM_DNS_DEFAULT_HOSTNAME` for all answers. If you want to define your own static mappings, you can add them to the file `/opt/inetsim/conf/user_configs/dns_static_mappings`. The syntax is `dns_static <domain> <ip>`.

### HTTP
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_HTTP_BIND_PORT` | Port number to bind HTTP service to. | `80` |
| `INETSIM_HTTP_VERSION` | Version string to return in HTTP replies. | `"INetSim HTTP server"` |
| `INETSIM_HTTP_FAKEMODE` | Turn HTTP fake mode on (`yes`) or off (`on`). | `yes` |

#### Fake Files
Fake files are returned by the INetSim HTTP server if `INETSIM_HTTP_FAKEMODE` is enabled. You can specify the files to return based on the file extension in the HTTP request of based on the query path. In any case, the files to serve must be placed in `/opt/inetsim/data/http/fakefiles`.

The [default mapping](default_service_configs/http_fakefiles) between extensions and files can be overridden by placing your own `http_fakefiles` mapping file into `/opt/inetsim/conf/user_configs`. The file has to contain one mapping per line; the syntax for a line is `http_fakefile <extension> <filename> <mime-type>`.

The same holds for the mapping between paths and files. Place your own `http_static_fakefiles` into `/opt/inetsim/conf/user_configs` and it will override the [default mapping](default_service_configs/http_static_fakefiles). The syntax is `http_static_fakefile <path> <filename> <mime-type>`.

### HTTPS
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_HTTPS_BIND_PORT` | Port number to bind HTTPS service to. | `443` |
| `INETSIM_HTTPS_VERSION` | Version string to return in HTTPS replies. | `"INetSim HTTPs server"` |
| `INETSIM_HTTPS_FAKEMODE` | Turn HTTPS fake mode on (`yes`) or off (`on`). | `yes` |

#### Fake Files
Fake files in the HTTPS service work in the same way as in the HTTP service (see above). Place a file called `https_fakefiles` into `/opt/inetsim/conf/user_configs` to override the [default](default_service_configs/https_fakefiles) mapping between file extensions and files (syntax: `https_fakefile <extension> <filename> <mime-type>`) and a file called `http_static_fakefiles` to `/opt/inetsim/conf/user_configs` to override the [default](default_service_configs/https_static_fakefiles) mapping between paths and files.

#### SSL/TLS
The HTTPS service expects the certificate under `/opt/inetsim/data/certs/https_cert.pem`, the key under `/opt/inetsim/data/certs/https_key.pem`, and the DH parameters under `/opt/inetsim/data/certs/https_dhparams.pem`. If they are not found, the default files are used.

### SMTP
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_SMTP_BIND_PORT` | Port number to bind SMTP service to. | `25` |
| `INETSIM_SMTP_FQDN_HOSTNAME` | The FQDN hostname used for SMTP. | `mail.inetsim.org` |
| `INETSIM_SMTP_BANNER` | The banner string used in SMTP greeting message. | `"INetSim Mail Service ready."` |
| `INETSIM_SMTP_HELO_REQUIRED` | Define whether the client has to send HELO/EHLO before any other command. | `yes` or `no` |
| `INETSIM_SMTP_EXTENDED_SMTP` | Turn support for extended smtp (ESMTP) on (`yes`) or off (`no`). | `yes` |
| `INETSIM_SMTP_AUTH_REVERSIBLEONLY` | Only offer authentication mechanisms which allow reversing the authentication information sent by a client to clear text username/password. This option only takes effect if `INETSIM_SMTP_EXTENDED_SMTP` is enabled and `smtp_service_extension AUTH` is configured. | `yes` or `no` |
| `INETSIM_SMTP_AUTH_REQUIRED` | Force the client to authenticate. This option only takes effect if `INETSIM_SMTP_EXTENDED_SMTP` is enabled and `smtp_service_extension AUTH` is configured. | `yes` or `no` |

#### SMTP Service Extensions
The [default SMTP service extensions](default_service_configs/smtp_service_extensions) offered to client can be overridden by placing a file called `smtp_service_extensions` into `/opt/inetsim/conf/user_configs`. The syntax per line is `smtp_service_extension <extension [parameter(s)]>`. Consider the INetSim documentation for a list of supported extensions.

#### SSL/TLS
The SMTP service expects the certificate under `/opt/inetsim/data/certs/smtp_cert.pem`, the key under `/opt/inetsim/data/certs/smtp_key.pem`, and the DH parameters under `/opt/inetsim/data/certs/smtp_dhparams.pem`. If they are not found, the default files are used.

### SMTPS
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_SMTPS_BIND_PORT` | Port number to bind SMTPS service to. | `465` |
| `INETSIM_SMTPS_FQDN_HOSTNAME` | The FQDN hostname used for SMTPS. | `mail.inetsim.org` |
| `INETSIM_SMTPS_BANNER` | The banner string used in SMTPS greeting message. | `"INetSim Mail Service ready."` |
| `INETSIM_SMTPS_HELO_REQUIRED` | Define whether the client has to send HELO/EHLO before any other command. | `yes` or `no` |
| `INETSIM_SMTPS_EXTENDED_SMTP` | Turn support for extended smtp (ESMTP) on (`yes`) or off (`no`). | `yes` |
| `INETSIM_SMTPS_AUTH_REVERSIBLEONLY` | Only offer authentication mechanisms which allow reversing the authentication information sent by a client to clear text username/password. This option only takes effect if `INETSIM_SMTPS_EXTENDED_SMTP` is enabled and `smtps_service_extension AUTH` is configured. | `yes` or `no` |
| `INETSIM_SMTPS_AUTH_REQUIRED` | Force the client to authenticate. This option only takes effect if `INETSIM_SMTPS_EXTENDED_SMTP` is enabled and `smtps_service_extension AUTH` is configured. | `yes` or `no` |

#### SMTPS Service Extensions
The [default SMTP service extensions](default_service_configs/smtps_service_extensions) offered to client can be overridden by placing a file called `smtps_service_extensions` into `/opt/inetsim/conf/user_configs`. The syntax per line is `smtps_service_extension <extension [parameter(s)]>`. Consider the INetSim documentation for a list of supported extensions.

#### SSL/TLS
The SMTPS service expects the certificate under `/opt/inetsim/data/certs/smtps_cert.pem`, the key under `/opt/inetsim/data/certs/smtps_key.pem`, and the DH parameters under `/opt/inetsim/data/certs/smtps_dhparams.pem`. If they are not found, the default files are used.

### POP3
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_POP3_BIND_PORT` | Port number to bind POP3 service to. | `110` |
| `INETSIM_POP3_BANNER` | The banner string used in POP3 greeting message. | `"INetSim POP3 Server ready"` |
| `INETSIM_POP3_HOSTNAME` | The hostname used in POP3 greeting message. | `pop3host` |
| `INETSIM_POP3_MBOX_MAXMAILS` | Maximum number of e-mails to select from supplied mbox files for creation of random POP3 mailbox | `10` |
| `INETSIM_POP3_MBOX_REREAD` | Re-read supplied mbox files if POP3 service was inactive for `INETSIM_POP3_MBOX_REREAD` seconds | `180` |
| `INETSIM_POP3_MBOX_REBUILD` | Rebuild random POP3 mailbox if POP3 service was inactive for `INETSIM_POP3_MBOX_REBUILD` seconds | `60` |
| `INETSIM_POP3_ENABLE_APOP` | Turn APOP on (`yes`) or off (`no`) | `yes` |
| `INETSIM_POP3_AUTH_REVERSIBLEONLY` | Only offer authentication mechanisms which allow reversing the authentication information sent by a client to clear text username/password | `yes` or `no` |
| `INETSIM_POP3_ENABLE_CAPABILITIES` | Turn support for pop3 capabilities on (`yes`) or off (`no`) | `yes` |

#### POP3 Capabilities
The [default POP3 capabilities](default_service_configs/pop3_capabilities) offered to client can be overridden by placing a file called `pop3_capabilities` into `/opt/inetsim/conf/user_configs`. The syntax per line is `pop3_capability <capability [parameter(s)]>`. Consider the INetSim documentation for a list of supported capabilities.

#### SSL/TLS
The POP3 service expects the certificate under `/opt/inetsim/data/certs/pop3_cert.pem`, the key under `/opt/inetsim/data/certs/pop3_key.pem`, and the DH parameters under `/opt/inetsim/data/certs/pop3_dhparams.pem`. If they are not found, the default files are used.

### POP3S
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_POP3S_BIND_PORT` | Port number to bind POP3S service to. | `995` |
| `INETSIM_POP3S_BANNER` | The banner string used in POP3 greeting message. | `"INetSim POP3 Server ready"` |
| `INETSIM_POP3S_HOSTNAME` | The hostname used in POP3 greeting message. | `pop3host` |
| `INETSIM_POP3S_MBOX_MAXMAILS` | Maximum number of e-mails to select from supplied mbox files for creation of random POP3 mailbox. | `10` |
| `INETSIM_POP3S_MBOX_REREAD` | Re-read supplied mbox files if POP3S service was inactive for `INETSIM_POP3S_MBOX_REREAD` seconds | `180` |
| `INETSIM_POP3S_MBOX_REBUILD` | Rebuild random POP3 mailbox if POP3S service was inactive for `INETSIM_POP3S_MBOX_REBUILD` seconds | `60` |
| `INETSIM_POP3S_ENABLE_APOP` | Turn APOP on (`yes`) or off (`no`) | `yes` |
| `INETSIM_POP3S_AUTH_REVERSIBLEONLY` | Only offer authentication mechanisms which allow reversing the authentication information sent by a client to clear text username/password. | `yes` or `no` |
| `INETSIM_POP3S_ENABLE_CAPABILITIES` | Turn support for pop3 capabilities on (`yes`) or off (`no`) | `yes` |

#### POP3 Capabilities
The [default POP3 capabilities](default_service_configs/pop3s_capabilities) offered to client can be overridden by placing a file called `pop3s_capabilities` into `/opt/inetsim/conf/user_configs`. The syntax per line is `pop3s_capability <capability [parameter(s)]>`. Consult the INetSim documentation for a list of supported capabilities.

#### SSL/TLS
The POP3S service expects the certificate under `/opt/inetsim/data/certs/pop3s_cert.pem`, the key under `/opt/inetsim/data/certs/pop3s_key.pem`, and the DH parameters under `/opt/inetsim/data/certs/pop3s_dhparams.pem`. If they are not found, the default files are used.

### TFTP
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_TFTP_BIND_PORT` | Port number to bind TFTP service to. | `69` |
| `INETSIM_TFTP_ALLOW_OVERWRITE` | Allow overwriting of existing files. |  `yes` or `no` | 
| `INETSIM_TFTP_ENABLE_OPTIONS` | Turn support for tftp options on (`yes`) or off (`no`) | `yes` |

#### TFTP Options
The [default](default_service_configs/tftp_options) can be overridden by placing a file called `tftp_options` into `/opt/inetsim/conf/user_configs`. The syntax per line is `tftp_option <option [parameter(s)]>`. Consult the INetSim documentation for a list of supported capabilities.

### FTP
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_FTP_BIND_PORT` | Port number to bind FTP service to. | `21` |
| `INETSIM_FTP_VERSION` | Version string to return in replies to the STAT command. | `"INetSim FTP Server"` |
| `INETSIM_FTP_BANNER` | The banner string used in FTP greeting message. | `"INetSim FTP Service ready."` |
| `INETSIM_FTP_RECURSIVE_DELETE` | Allow recursive deletion of directories, even if they are not empty. |  `yes` or `no` |

### FTPS
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_FTPS_BIND_PORT` | Port number to bind FTP service to. | `990` |
| `INETSIM_FTPS_VERSION` | Version string to return in replies to the STAT command. | `"INetSim FTPs Server"` |
| `INETSIM_FTPS_BANNER` | The banner string used in FTP greeting message. | `"INetSim FTP Service ready."` |
| `INETSIM_FTPS_RECURSIVE_DELETE` | Allow recursive deletion of directories, even if they are not empty. |  `yes` or `no` |

#### SSL/TLS
The POP3S service expects the certificate under `/opt/inetsim/data/certs/ftps_cert.pem`, the key under `/opt/inetsim/data/certs/ftps_key.pem`, and the DH parameters under `/opt/inetsim/data/certs/ftps_dhparams.pem`. If they are not found, the default files are used.

### NTP
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_NTP_BIND_PORT` | Port number to bind NTP service to. | `123` |
| `INETSIM_NTP_SERVER_IP` | The IP address to return in NTP replies. | `10.15.20.30` |
| `INETSIM_NTP_STRICT_CHECKS` | Turn strict checks for client packets on (`yes`) or off (`no`). | `yes` |

### IRC
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_IRC_BIND_PORT` | Port number to bind IRC service to. | `6667` |
| `INETSIM_IRC_FQDN_HOSTNAME` | The FQDN hostname used for IRC | `irc.inetsim.org` |
| `INETSIM_IRC_VERSION` | Version string to return. | `"INetSim IRC Server"` |

### Time
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_TIME_BIND_PORT` | Port number to bind time service to. | `37` |

### Daytime
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_DAYTIME_BIND_PORT` | Port number to bind daytime service to. | `13` |

### Echo
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_ECHO_BIND_PORT` | Port number to bind echo service to. | `7` |

### Discard
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_DISCARD_BIND_PORT` | Port number to bind discard service to. | `9` |

### QOTD
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_QUOTD_BIND_PORT` | Port number to bind quotd service to. | `17` |

### Chargen
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_CHARGEN_BIND_PORT` | Port number to bind chargen service to. | `19` |

### Finger
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_FINGER_BIND_PORT` | Port number to bind finger service to. | `79` |

### Ident
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_IDENT_BIND_PORT` | Port number to bind ident service to. | `113` |

### Syslog
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_SYSLOG_BIND_PORT` | Port number to bind syslog service to. | `514` |
| `INETSIM_SYSLOG_TRIM_MAXLENGTH` | Chop syslog messages at 1024 bytes. | `yes` or `no` |
| `INETSIM_SYSLOG_ACCEPT_INVALID` | Accept invalid syslog messages. | `yes` or `no` |

### Dummy
| Parameter | Description | Example |
| --- | --- | --- |
| `INETSIM_DUMMY_BIND_PORT` | Port number to bind dummy service to. | `1` |
| `INETSIM_DUMMY_BANNER` | Banner string sent to client if no data has been received for 'INETSIM_DUMMY_BANNER_WAIT' seconds since the client has established the connection. If set to an empty string (`""`), only CRLF will be sent. This option only takes effect if 'INETSIM_DUMMY_BANNER_WAIT' is not set to `0`. | `"220 ESMTP FTP +OK POP3 200 OK"` |
| `INETSIM_DUMMY_BANNER_WAIT` | Number of seconds to wait for client sending any data after establishing a new connection. If no data has been received within this amount of time, 'INETSIM_DUMMY_BANNER' will be sent to the client. Setting to `0` disables sending of a banner string. | `5` |
