#!/bin/bash
# Script to quickly startup a git and ci server with a pastebin for developmeny
# Update the lines below with your domain, then setup your dns to be git.yourdomain and ci.yourdomain
$MYDOMAIN=example.com
$ADMINUSER=user
$MYORG=example

$GITSECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
$CISECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

mkdir -p /etc/nginx/sites-enabled/
mkdir -p /var/www/.well-known

cd /var/www/
git clone https://github.com/olymk2/project-hosting-setup.git

cd /var/www/project-hosting-setup
cp env.sample .env
sed -i "s/exampleorg/${ADMINUSER}/g" .env
sed -i "s/adminuser/${MYORG}/g" .env
sed -i "s/example.com/${MYDOMAIN}/g" .env
sed -i "s/giteapassword/${GITSECRET}/g" .env
sed -i "s/drone-random-secret-here/${CISECRET}/g" .env

sed -i "s/mydomain.com/${MYDOMAIN}/g" config/git.mydomain.com
sed -i "s/mydomain.com/${MYDOMAIN}/g" config/ci.mydomain.com
sed -i "s/mydomain.com/${MYDOMAIN}/g" config/pastebin.mydomain.com

cp config/git.mydomain.com "/etc/nginx/sites-enabled/git.${MYDOMAIN}"
cp config/ci.mydomain.com "/etc/nginx/sites-enabled/ci.${MYDOMAIN}"
cp config/pastebin.mydomain.com "/etc/nginx/sites-enabled/pastebin.${MYDOMAIN}"
cp config/redirect_https "/etc/nginx/sites-enabled/redirect_https"


docker-compose up -d
