ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
IMAGE:=mozilla-sa-crasher

build:
	docker build . -t $(IMAGE)

container: require-creds
container: require-patch
container:
	docker run -it --env-file=dev.env --env-file=.creds -v $(ROOT_DIR)/cache:/cache -v $(realpath $(patch)):/patch.diff:ro $(IMAGE) $(cmd)

shell: cmd=bash
shell: container

crash: cmd=crasher
crash: container

require-creds:
	@if [ ! -f ".creds" ]; then echo "Missing phabricator credentials (in .creds)"; exit 1; fi

require-patch:
	@if [ ! $(patch) ]; then echo "Missing patch variable. Use make cmd patch=patches/xxx.diff"; exit 1; fi
	@if [ ! -f $(patch) ]; then echo "Patch does not exists: $(patch)"; exit 1; fi
