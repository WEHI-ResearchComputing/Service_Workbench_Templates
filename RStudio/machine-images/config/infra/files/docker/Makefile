#!/usr/bin/env make
# vim: tabstop=8 noexpandtab

image_name=rocker_tidyverse_4.3.0
aws_account_location=010045907075.dkr.ecr.ap-southeast-2.amazonaws.com
name_and_tag=$(image_name):$(image_tag)

docker-build: ## make docker-build image_tag=1
	docker build \
		-t $(name_and_tag) \
		-f Dockerfile \
		.

docker-publish: ## make docker-publish image_tag=1
	aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin $(aws_account_location)
	docker tag $(name_and_tag) $(aws_account_location)/$(name_and_tag)
	docker push $(aws_account_location)/$(name_and_tag)
