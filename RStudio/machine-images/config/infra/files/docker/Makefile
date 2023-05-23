#!/usr/bin/env make
# vim: tabstop=8 noexpandtab

image_name=rocker_tidyverse_4-3-0_goofys_paws_bioconductor
aws_public_account_location=public.ecr.aws/h3j5s9c2
name_and_tag=$(image_name):$(image_tag)

docker-build: ## make docker-build image_tag=1
	docker build \
		-t $(name_and_tag) \
		-f Dockerfile \
		.

docker-publish: ## make docker-publish image_tag=1
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(aws_public_account_location)
	docker tag $(name_and_tag) $(aws_public_account_location)/$(name_and_tag)
	docker push $(aws_public_account_location)/$(name_and_tag)
