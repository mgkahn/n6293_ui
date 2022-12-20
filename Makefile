.PHONY: build-buildx build from-scratch buildx-push check run debug push save clean clobber

# Default values for variables
REPO  ?= mgkahn/
NAME  ?= ui
TAG   ?= latest

VOLUME=$(NAME)_vol
NETWORK=n6293_net
SHARED=Transfer_Station
PORT=6080
USER_ID=`id -u`
USER_NAME=`id -n -u`

ARCH  := $$(arch=$$(uname -m); if [[ $$arch == "x86_64" ]]; then echo amd64; else echo $$arch; fi)RCH  := $$(arch=$$(uname -m); if [[ $$arch == "x86_64" ]]; then echo amd64; else echo $$arch; fi)
ARCHS = amd64 arm64
IMAGES := $(ARCHS:%=$(REPO)$(NAME):$(TAG)-%)
PLATFORMS := $$(first="True"; for a in $(ARCHS); do if [[ $$first == "True" ]]; then printf "linux/%s" $$a; first="False"; else printf ",linux/%s" $$a; fi; done)

# These files will be generated from teh Jinja templates (.j2 sources)
templates = Dockerfile rootfs/etc/supervisor/conf.d/supervisord.conf

build-buildx:
	docker buildx create --name mybuilder --use --bootstrap

# Rebuild the container image and remove intermediary images
build: $(templates)
	docker build --tag $(REPO)$(NAME):$(TAG) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [[ $$danglingimages != "" ]]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

from-scratch: $(templates)
	docker build --no-cache --tag $(REPO)$(NAME):$(TAG) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [[ $$danglingimages != "" ]]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

buildx-push: $(templates)
	docker buildx build --push --platform linux/amd64,linux/arm64 --tag $(REPO)$(NAME):$(TAG) .

buildx-from-scratch: $(templates)
	docker buildx build --no-cache --push --platform linux/amd64,linux/arm64 --tag $(REPO)$(NAME):$(TAG) .


run:
	docker volume create ${VOLUME}
	
	## Only create network if it isn't present
	## FROM https://stackoverflow.com/questions/48643466/docker-create-network-should-ignore-existing-network
	## FOR WINDOWS/Powershell
	#
	# $networkName = "fb_net"
	#
	# if (docker network ls | select-string $networkName -Quiet )
	# {
	#     Write-Host "$networkName already created"
	# } else {
	#     docker network create $networkName
	# }

	## FOR LINUX.
	docker network inspect ${NETWORK} --format {{.Id}} 2>/dev/null || docker network create --driver bridge ${NETWORK}


	docker run --rm --detach \
	--publish ${PORT}:80 \
	--volume "${PWD}":/workspace:rw \
	--volume ${VOLUME}:/home/${USER_NAME}:rw \
	--volume "${HOME}"/Desktop/${SHARED}:/home/${USER_NAME}/Desktop/${SHARED}:rw \
	--env USERNAME=$(USER_NAME) --env USERID=$(USER_ID) \
	--env PASSWORD="nurs6293" \
	--network ${NETWORK} \
	--name ${NAME} \
	$(REPO)$(NAME):$(TAG)

	echo "Sleeping for 5 seconds for start-up"
	sleep 5
	echo "open -a 'Google Chrome' http://localhost:${PORT}"|bash \
	|| exec bash 'xdg-open http://localhost:${PORT}' \
	|| echo "Point your web browser at http://localhost:${PORT}"

push:
	docker push $(REPO)$(NAME):$(TAG)

save:
	docker save $(REPO)$(NAME):$(TAG) | gzip > $(NAME)-$(TAG).tar.gz

clean:
	docker image prune -f

clobber:
	docker rmi $(REPO)$(NAME):$(TAG) $(REPO)$(NAME):$(TAG)
	docker builder prune --all
