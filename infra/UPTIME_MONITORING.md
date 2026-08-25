# Uptime Monitoring — UptimeRobot

Static site `https://qouver.com` (and analytics subdomain) are monitored with
**UptimeRobot** — a managed service with a free tier. Zero infrastructure on
the VPS; nothing extra to run in podman.

## Why UptimeRobot

- Free tier: 50 monitors, 5-min interval, email alerts. Plenty for this site.
- Managed — no extra container to maintain on the VPS (unlike self-hosting
  Uptime Kuma next to Umami).
- Also checks **SSL certificate expiry** on the same monitors.
- Alternative considered: Healthchecks.io — better fit for cron/background
  jobs, not for public HTTP endpoint monitoring.

## Setup (one-time, ~5 minutes)

1. Create an account at https://uptimerobot.com
2. **Add New Monitor** → type `HTTPS`:
   - Friendly name: `qouver.com`
   - URL: `https://qouver.com`
   - Interval: 5 minutes
   - Alert contacts: your email
3. Repeat for:
   - `https://www.qouver.com` (if apex redirect is in place, monitor the 301)
   - `https://analytics.qouver.com` (Umami dashboard)
4. SSL expiry alerts are automatic per monitor.

## Incident response

- Email alert → SSH to VPS → `sudo systemctl status caddy` and
  `podman ps` (Umami/Postgres).
- Site is fully static (files served by Caddy) — a full outage usually means
  the VPS or Caddy itself is down.
- After recovery, verify with:
  ```bash
  curl -I https://qouver.com
  curl -I https://analytics.qouver.com
  ```

## Optional: automate monitor creation

UptimeRobot has a REST API. To create monitors programmatically:

```bash
curl -s -X POST https://api.uptimerobot.com/v2/newMonitor \
  -H "Content-Type: application/json" \
  -d '{"api_key":"UPTIMEROBOT_API_KEY","type":1,"url":"https://qouver.com","friendly_name":"qouver.com","interval":300,"alert_contacts":""}'
```

Get an API key at Settings → API Settings. Keep it in your secrets store
(never commit it).
