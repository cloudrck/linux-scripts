#!/bin/bash
#################
# Change this values
#################
# This script assumes you're running as a privileged non-root user
#

appuser="koko28"
apppass="pass123"
domain="d1.example.com"


#################
# Dependicies
#################
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get install nginx nano curl

cat <<EOT >> mainapp.conf
# use the socket we configured in our unicorn.rb
upstream dev1.cloudrck.net {
  server unix:/tmp/unicorn.VidSite.socket
      fail_timeout=0;
}
server {
  listen 80;
  server_name dev1.cloudrck.net;
  root /home/mvidy/VidSite/public;
  error_log /var/log/nginx-error.log;
  # maximum accepted body size of client request
  client_max_body_size 4G;
  # the server will close connections after this time
  keepalive_timeout 5;

  location / {
    try_files $uri @app;
  }

  location @app {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
    # pass to the upstream unicorn server mentioned above
    proxy_pass http://dev1.cloudrck.net;
  }
}
EOT


sudo adduser $appuser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "$appuser:$apppass" | sudo chpasswd


exit 1
