# ga-nextcloud-sip-trip

Minimal Railway deployment for Nextcloud with SIP Trip Phone proxying straight to Telnyx.

## What this repo contains
- **Dockerfile** that extends `nextcloud:stable-apache`, enables the required Apache modules, and loads an extra proxy config.
- **sip-trip-phone.conf** Apache configuration so the SIP Trip Phone app can reach Telnyx via WebSocket/SIP over WebSocket and exposes the `/phone/` entry point inside Nextcloud.

## Deploying on Railway (summary)
1. Create a PostgreSQL instance in Railway and note `POSTGRES_HOST`, `POSTGRES_DB`, `POSTGRES_USER`, and `POSTGRES_PASSWORD`.
2. Create a new service from this repo. Set the internal port to **80**.
3. Attach a volume (ideally mounted at `/var/www/html`) for persistent data.
4. Add environment variables:
   ```text
   POSTGRES_HOST=<railway-pg-host>
   POSTGRES_DB=nextcloud
   POSTGRES_USER=nextcloud
   POSTGRES_PASSWORD=<super-secure-password>

   NEXTCLOUD_ADMIN_USER=admin
   NEXTCLOUD_ADMIN_PASSWORD=<strong-admin-pass>
   NEXTCLOUD_TRUSTED_DOMAINS=cloud.genericalternatives.co.uk
   NEXTCLOUD_DATA_DIR=/var/www/html/data
   ```
5. Point your DNS (e.g., `cloud.genericalternatives.co.uk`) at the Railway service and add the custom domain in Railway.
6. In Nextcloud, install **SIP Trip Phone** from the app store and configure it with your Telnyx WebRTC credentials (`sip.telnyx.com:7443`, WSS, SIP username/password, outbound number).

With that, `https://cloud.genericalternatives.co.uk` will serve Nextcloud and tunnel SIP Trip Phone traffic to Telnyx.
