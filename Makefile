# Short name: Short name, following [a-zA-Z_], used all over the place.
# Some uses for short name:
# - Docker image name
# - Kubernetes service, rc, pod, secret, volume names
SHORT_NAME := redis
DRYCC_REGISTY ?= ${DEV_REGISTRY}
IMAGE_PREFIX ?= drycc

include versioning.mk

SHELL_SCRIPTS = $(wildcard _scripts/*.sh) rootfs/bin/boot

# The following variables describe the containerized development environment
# and other build options
DEV_ENV_IMAGE := drycc/go-dev
DEV_ENV_WORK_DIR := /go/src/${REPO_PATH}
DEV_ENV_CMD := docker run --rm -v ${CURDIR}:${DEV_ENV_WORK_DIR} -w ${DEV_ENV_WORK_DIR} ${DEV_ENV_IMAGE}
DEV_ENV_CMD_INT := docker run -it --rm -v ${CURDIR}:${DEV_ENV_WORK_DIR} -w ${DEV_ENV_WORK_DIR} ${DEV_ENV_IMAGE}

all: docker-build docker-push

dev:
	${DEV_ENV_CMD_INT} bash

# For cases where we're building from local
# We also alter the RC file to set the image name.
docker-build:
	docker build ${DOCKER_BUILD_FLAGS} -t ${IMAGE} rootfs
	docker tag ${IMAGE} ${MUTABLE_IMAGE}

test: test-style

test-style:
	${DEV_ENV_CMD} shellcheck $(SHELL_SCRIPTS)
