include .env

API_PORT=3000
WEB_PORT=3001

# API DOCKER IMAGE

api-build:
	@echo "Building api image"
	cd api; \
		docker build -t api:$(API_IMAGE_TAG) --rm .

api-run:
	@echo "Running api image"
	cd api; \
		cp ../.env . ; \
		docker run --name api \
		--env-file .env \
		-p $(API_PORT):3000 \
		-d api:$(API_IMAGE_TAG)

api-stop:
	@echo "Stopping api image"
	cd api; \
		docker stop api && docker rm api

api-tag:
	@echo "Tagging api image"
	cd api; \
		docker tag \
		api:$(API_IMAGE_TAG) \
		$(AWS_ECR_API):$(API_IMAGE_TAG)

api-release:
	@echo "Releasing api image"
	$$(aws ecr get-login \
		--no-include-email \
		--region $(AWS_REGION) | tr -d '\r')
	cd api; \
		docker push $(AWS_ECR_API):$(API_IMAGE_TAG)

# WEB DOCKER IMAGE

web-build:
	@echo "Building web image"
	cd web; \
		docker build -t web:$(WEB_IMAGE_TAG) --rm .

web-run:
	@echo "Running web image"
	cd web; \
		cp ../.env . ; \
		docker run --name web \
		--env-file .env \
		-p $(WEB_PORT):3000 \
		-d web:$(WEB_IMAGE_TAG)

web-stop:
	@echo "Stopping web image"
	cd web; \
		docker stop web && docker rm web

web-tag:
	@echo "Tagging web image"
	cd web; \
		docker tag \
		web:$(WEB_IMAGE_TAG) \
		$(AWS_ECR_WEB):$(WEB_IMAGE_TAG)

web-release:
	@echo "Releasing web image"
	$$(aws ecr get-login \
		--no-include-email \
		--region $(AWS_REGION) | tr -d '\r')
	cd web; \
		docker push $(AWS_ECR_WEB):$(WEB_IMAGE_TAG)

