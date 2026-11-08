# DROPERAGENT — WordPress + WooCommerce online

This deployment uses the **existing `sebastisnzoth/WordPress` repository** to manage an independent WordPress stack. Its 2018 WordPress 5.0-alpha source code in `master` is **not used as the production runtime**. Instead, official current WordPress and MariaDB Docker images are pulled during deployment to avoid exposing the insecure legacy core.

## Requirements

- A Linux VPS or compatible persistent host with Docker Compose v2 and public inbound ports 80/443.
- A domain pointing to that host and accessible by Let's Encrypt.
- Sufficient memory/storage for MariaDB + WordPress + WooCommerce.
- Persistent container volumes and a **separate off-server backup destination**.
- Your own administrator credentials. None are committed to this repository.

> GitHub Pages, GitHub Actions runners and a free ephemeral Node container are not persistent WordPress hosting. A GitHub repository alone does not expose a live WordPress service.

## Deployment (authorized host)

1. Clone this repository onto the intended **persistent** server.
2. `cd deploy && cp .env.example .env`, enter `SITE_DOMAIN` and unique `DB_PASSWORD`, `DB_ROOT_PASSWORD`.
3. Run `docker compose config --quiet` to validate all required settings.
4. Run `docker compose up -d database wordpress https` to start MariaDB, WordPress and Caddy HTTPS. The certificate is issued only once DNS points at the server.
5. Open `https://YOUR_DOMAIN/wp-admin/install.php` and complete WordPress administration. Use strong credentials and keep the site closed to customers until testing finishes.
6. Configure site language `Português do Brasil` and store currency `BRL`. Install WooCommerce from **Plugins → Add New → WooCommerce**, activate it, and follow the WooCommerce store wizard.
7. In WooCommerce → Settings → Advanced → REST API create a dedicated API key for the DROPERAGENT test backend. **Never store or commit keys in this repo, GitHub Pages, or frontend build variables.**
8. Verify `GET https://YOUR_DOMAIN/wp-json/` over HTTPS, then separately verify the backend can authenticate and create/read a **draft** product over the WooCommerce REST API.

## Maintain / protect

- This is an **independent WordPress application** and does not change UGO or DROPERAGENT's existing GitHub Pages frontend.
- MariaDB, WordPress and Caddy certificate material live in Docker named volumes. `docker compose down -v` **destroys data**; never run it on a production store.
- `bash backup.sh` exports a local MariaDB snapshot into `deploy/backups/`, but **uploads and plugin files also require a separate volume backup**. Copy encrypted backups to an independent location and test restoration before accepting orders.
- Update the official WordPress image, WooCommerce plugin, PHP and MariaDB with backups and staged validation. Avoid mounting the historical 2018 source tree.
- Use only official integrations for DSers/AliExpress. No real purchases, order fulfillment or publication without explicit authorization.

## Status

Configuration files are committed to GitHub, **not deployed**. An online installation requires a persistent host/domain or an existing authorized WordPress hosting provider. There is no safe assumption that `https://sebastisnzoth.github.io/WordPress/` can run PHP or MariaDB.

Integration target: `sebastisnzoth/droperagent` and its API. That backend must have secure WooCommerce API credentials and an HTTPS public endpoint before enabling LIVE in the dashboard.
