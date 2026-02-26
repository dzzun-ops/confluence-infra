.PHONY: deploy pull

up:
	docker compose up -d

down:
	docker compose down

pull:
	# Clone or pull latest
	if [ ! -d "backend" ]; then git clone https://$${GH_TOKEN}@github.com/dzzun-ops/confluence-backend.git backend; else cd backend && git pull && cd ..; fi
	if [ ! -d "frontend" ]; then git clone https://$${GH_TOKEN}@github.com/dzzun-ops/confluence-frontend.git frontend; else cd frontend && git pull && cd ..; fi

deploy: pull
	docker compose build
	docker compose up -d
	docker compose exec nginx nginx -s reload
