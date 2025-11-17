FROM nextcloud:stable-apache

# Enable modules needed for SIP Trip Phone + reverse proxy
RUN a2enmod rewrite headers env dir mime setenvif \
    proxy proxy_http proxy_wstunnel ssl

# Add SIP Trip Phone Apache config
COPY sip-trip-phone.conf /etc/apache2/conf-enabled/sip-trip-phone.conf
