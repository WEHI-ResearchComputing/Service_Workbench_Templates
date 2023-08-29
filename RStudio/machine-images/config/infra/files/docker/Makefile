#!/usr/bin/env make
# vim: tabstop=8 noexpandtab

image_tag=1
image_name=analysisenv
name_and_tag=$(image_name):$(image_tag)
aws_account_location=010045907075.dkr.ecr.ap-southeast-2.amazonaws.com

docker-build:
	docker build \
		-t $(name_and_tag) \
		-f Dockerfile \
		--build-arg SET_PASSWORD_TO=0oNFvILIG3oiVmTw \
		.

docker-publish:
	aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin $(aws_account_location)
	docker tag $(name_and_tag) $(aws_account_location)/$(name_and_tag)
	docker push $(aws_account_location)/$(name_and_tag)
