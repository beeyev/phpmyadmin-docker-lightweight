#!/bin/sh

#String Colors
NC='\033[0;m'      # Default Color
GRN='\033[32;1m'
RED='\033[31;1m'
BLK='\033[30;1m'

# Set the number of cpu cores
export NUM_CPUS=`nproc`

# Run custom script before the main docker process gets started
for f in /docker-entrypoint.init.d/*; do
    case "$f" in
        *.sh) # this should match the set of files we check for below
            echo "⚙	 Executing entrypoint.init file: ${f}"
            . $f
            break
            ;;
    esac
done

printf "\n${GRN}--->${NC} 	🚀️️	 Welcome to ${GRN}beeyev phpMyAdmin v.${VERSION} lightweight${NC} container..."
printf "\n${GRN}--->${NC} Docker image build date: ${GRN}${BUILD_DATE}${NC}, fingerprint: ${GRN}${BUILD_FINGERPRINT}${NC}"
printf "\n${GRN}--->${NC} Subscribe to project updates: ${GRN}https://github.com/beeyev/phpmyadmin-docker-lightweight${NC}\n\n"

caddy start --adapter caddyfile --config /etc/caddy/Caddyfile

exec /phpmyadmin-docker-entrypoint.sh php-fpm
