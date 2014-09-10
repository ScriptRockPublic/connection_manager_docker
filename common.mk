
ifeq ($(DOCKER_IMAGE_NAME),)
	$(error DOCKER_IMAGE_NAME is not set)
endif

default:
	@echo Run 'make build' then 'make run_interactive' or 'make run_daemon'

build:
	sudo docker build -t $(DOCKER_IMAGE_NAME) .

DOCKER_RUN_ARGS = -v $(HOME)/.scriptrock/:/mnt/scriptrock_conf/ -t $(DOCKER_IMAGE_NAME)

run_interactive:
	sudo docker run -i $(DOCKER_RUN_ARGS)

run_daemon:
	sudo docker run --detach=true $(DOCKER_RUN_ARGS)

run_noop:
	sudo docker run -i --entrypoint=/bin/sh $(DOCKER_RUN_ARGS) -c true 

export:
	sudo docker export `sudo docker run -d --entrypoint=/bin/sh $(DOCKER_RUN_ARGS) -c true` > $(DOCKER_IMAGE_NAME).tar

.PHONY: default build run_interactive run_daemon run_noop export

