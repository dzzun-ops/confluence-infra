# confluence-infra

Production infra for `wiki.veloxico.com`.

## Architecture
- Host Nginx on VPS: entrypoint `80/443`
- `frontend` container on `127.0.0.1:13000`
- `backend` container on `127.0.0.1:13001`
- `backend ws` on `127.0.0.1:1234`
- `postgres/redis/minio/meilisearch` only in internal docker network

## Deploy
```bash
cd /opt/app/confluence
cp .env.example .env   # fill secrets
export GH_TOKEN=<token-with-repo-read>
make pull
docker compose build
docker compose up -d
```

## Nginx
Install config:
```bash
cp nginx.conf /etc/nginx/sites-available/wiki.veloxico.com
ln -s /etc/nginx/sites-available/wiki.veloxico.com /etc/nginx/sites-enabled/wiki.veloxico.com
nginx -t && systemctl reload nginx
```

## SSL
```bash
certbot --nginx -d wiki.veloxico.com --redirect
```

## Checks
```bash
docker ps
curl -I http://127.0.0.1:13000
curl -I http://127.0.0.1:13001/api
curl -I https://wiki.veloxico.com
curl -I https://wiki.veloxico.com/api
```

## Rollback
```bash
cd /opt/app/confluence/backend && git log --oneline -n 5
cd /opt/app/confluence/frontend && git log --oneline -n 5
# checkout previous known-good commit on both repos, then:
cd /opt/app/confluence && docker compose build && docker compose up -d
```
