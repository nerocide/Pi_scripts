#!/bin/bash
sudo apt-get -y install haproxy
echo "Generating SSL certificate"
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem
cat cert.pem > tmp.pem
cat key.pem >> tmp.pem 
cp tmp.pem /etc/ssl/private/cert.pem
# Setup Haproxy
echo "global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http
	option redispatch
	option http-server-close
	option forwardfor

frontend public
        bind *:80
        bind *:443 ssl crt /etc/ssl/private/cert.pem
	#redirect scheme https code 301 if !{ ssl_fc }
        use_backend webcam if { path_beg /webcam/ }
	reqadd X-Forwarded-Proto:\ http
	reqadd X-Forwarded-Proto:\ https
	default_backend octoprint

backend octoprint
        option forwardfor
        server octoprint1 127.0.0.1:5000
	reqadd X-Scheme:\ https if { ssl_fc }

backend webcam
        reqrep ^([^\ :]*)\ /webcam/(.*)     \1\ /\2
        server webcam1 127.0.0.1:8080
" > /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy
sudo systemctl enable haproxy
