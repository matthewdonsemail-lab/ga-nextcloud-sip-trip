# ga-nextcloud-sip-trip

Minimal Railway deployment for Nextcloud with SIP Trip Phone proxying straight to Telnyx.

## What this repo contains
- **Dockerfile** that extends `nextcloud:stable-apache`, enables the required Apache modules, and loads an extra proxy config.
- **sip-trip-phone.conf** Apache configuration so the SIP Trip Phone app can reach Telnyx via WebSocket/SIP over WebSocket and exposes the `/phone/` entry point inside Nextcloud.

## Deploying on Railway (summary)
1. Create a PostgreSQL instance in Railway and note `POSTGRES_HOST`, `POSTGRES_DB`, `POSTGRES_USER`, and `POSTGRES_PASSWORD`.
2. Create a new service from this repo. In the Railway UI, set **Target port** to **80** (the container listens on 80 even if the public URL uses 8080).
3. Attach a volume (ideally mounted at `/var/www/html`; if Railway only offers `/mnt/data`, set `NEXTCLOUD_DATA_DIR=/mnt/data` instead) for persistent data.
4. Add environment variables:
   ```text
   POSTGRES_HOST=<railway-pg-host>
   POSTGRES_DB=nextcloud
   POSTGRES_USER=nextcloud
   POSTGRES_PASSWORD=<super-secure-password>

   NEXTCLOUD_ADMIN_USER=admin
   NEXTCLOUD_ADMIN_PASSWORD=<strong-admin-pass>
   NEXTCLOUD_TRUSTED_DOMAINS=<your-railway-domain>
   NEXTCLOUD_DATA_DIR=/var/www/html/data
   ```
   Example: if Railway assigns `ga-nextcloud-sip-trip-production.up.railway.app`, set `NEXTCLOUD_TRUSTED_DOMAINS=ga-nextcloud-sip-trip-production.up.railway.app`.
5. If you do not have a custom domain, you can use the default Railway URL (e.g., `https://ga-nextcloud-sip-trip-production.up.railway.app`). If you later add a custom domain, append it to `NEXTCLOUD_TRUSTED_DOMAINS` (comma-separated) and add it in the Railway UI.
6. In Nextcloud, install **SIP Trip Phone** from the app store and configure it with your Telnyx WebRTC credentials (`sip.telnyx.com:7443`, WSS, SIP username/password, outbound number).
7. For SIP Trip Phone to work, the Apache config here proxies the **URL path** `/apps/sip_trip_phone/lib` to Telnyx (`wss://sip.telnyx.com:7443`). After redeploying, the SIP Trip Phone app’s WebSocket requests should show as proxied in your Railway logs.

Railway’s public URL (or your custom domain) will serve Nextcloud and tunnel SIP Trip Phone traffic to Telnyx. The Apache log warning about `ServerName` has been silenced in the image.
