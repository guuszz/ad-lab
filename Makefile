DC_CONTAINER = lab-dc01
COMPOSE = docker compose -f docker/docker-compose.yml

.PHONY: up down reset shell logs status provision attack attack-shell report clean

up:
	$(COMPOSE) up -d --build
	@echo "[*] Aguardando provisionamento; acompanhe com: make logs"

down:
	$(COMPOSE) down

reset:
	$(COMPOSE) down -v
	$(MAKE) up

shell:
	docker exec -it $(DC_CONTAINER) bash

logs:
	$(COMPOSE) logs -f dc

status:
	docker ps --filter "name=$(DC_CONTAINER)"

provision: up

attack:
	docker exec lab-attacker bash /opt/attacks/run-all.sh

attack-shell:
	docker exec -it lab-attacker bash

report:
	docker exec lab-attacker cat /opt/attacks/report.md

clean: down
	$(COMPOSE) down -v
	docker system prune -f
