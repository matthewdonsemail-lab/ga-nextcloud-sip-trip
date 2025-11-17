FROM nextcloud:stable-apache

# Enable modules needed for SIP Trip Phone + reverse proxy
RUN a2enmod rewrite headers env dir mime setenvif \
    proxy proxy_http proxy_wstunnel ssl

# Avoid Apache ServerName warnings in logs
RUN echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername

# Add SIP Trip Phone Apache config
COPY sip-trip-phone.conf /etc/apache2/conf-enabled/sip-trip-phone.conf
