#!/bin/bash
set -eu

DATADIR='/opt/inetsim/data'
DEFAULT_DATA='/opt/inetsim/default_data'


function create_tls_files()
{
    if [ ! -f $DATADIR/certs/$1_key.pem ]; then
        ln -s $DATADIR/certs/default_key.pem $DATADIR/certs/$1_key.pem
    fi
    if [ ! -f $DATADIR/certs/$1_cert.pem ]; then
        ln -s $DATADIR/certs/default_cert.pem $DATADIR/certs/$1_cert.pem
    fi
    if [ ! -f $DATADIR/certs/$1_dhparams.pem ]; then
        ln -s $DATADIR/certs/default_dhparams.pem $DATADIR/certs/$1_dhparams.pem
    fi
}


mkdir -p $DATADIR/certs
if [ ! -f $DATADIR/certs/default_dhparams.pem ]; then
    openssl dhparam -out $DATADIR/certs/default_dhparams.pem -outform PEM 1024
fi
if [ ! -e $DATADIR/certs/default_cert.pem ]; then
    cp $DEFAULT_DATA/certs/default_cert.pem $DATADIR/certs/
fi
if [ ! -e $DATADIR/certs/default_key.pem ]; then
    cp $DEFAULT_DATA/certs/default_key.pem $DATADIR/certs/
fi

# Service Finger
if [ ! -d $DATADIR/finger ]; then
    mkdir -p $DATADIR/finger
    cp $DEFAULT_DATA/finger/example.finger $DATADIR/finger/
fi

# Service FTP/FTPS
mkdir -p $DATADIR/ftp/upload
if [ ! -d $DATADIR/ftp/tftproot ]; then
    cp -r $DEFAULT_DATA/ftp/ftproot $DATADIR/ftp/
fi
create_tls_files ftps

# Service HTTP
mkdir -p $DATADIR/http/postdata
if [ ! -f $DATADIR/http/mime.types ]; then
    cp $DEFAULT_DATA/http/mime.types $DATADIR/http/mime.types
fi
if [ ! -d $DATADIR/http/fakefiles ]; then 
    cp -r $DEFAULT_DATA/http/fakefiles $DATADIR/http/
fi
if [ ! -d $DATADIR/http/wwwroot ]; then
    cp -r $DEFAULT_DATA/http/wwwroot $DATADIR/http/
fi
create_tls_files https

# Service POP3
if [ ! -d $DATADIR/pop3 ]; then
    cp -r $DEFAULT_DATA/pop3 $DATADIR/
fi
create_tls_files pop3
create_tls_files pop3s

# Service QOTD
mkdir -p $DATADIR/quotd
if [ ! -f $DATADIR/quotd/quotd.txt ]; then
    cp $DEFAULT_DATA/quotd/quotd.txt $DATADIR/quotd/quotd.txt
fi

# Service SMTP/SMTPS
mkdir -p $DATADIR/smtp
create_tls_files smtp
create_tls_files smtps

# Service TFTP
mkdir -p $DATADIR/tftp/upload
if [ ! -d $DATADIR/tftp/tftproot ]; then
    cp -r $DEFAULT_DATA/tftp/tftproot $DATADIR/tftp/
fi
