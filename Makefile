ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
IMAGE:=mozilla-sa-crasher

build:
	docker build . -t $(IMAGE)

crash: require-creds
crash: require-patch
crash:
	docker run -it --env-file=dev.env --env-file=.creds -v $(ROOT_DIR)/cache:/cache -v $(realpath $(patch)):/patch.diff:ro $(IMAGE)

require-creds:
	@if [ ! -f ".creds" ]; then echo "Missing phabricator credentials (in .creds)"; exit 1; fi

require-patch:
	@if [ ! $(patch) ]; then echo "Missing patch variable. Use make crash patch=patches/xxx.diff"; exit 1; fi
	@if [ ! -f $(patch) ]; then echo "Patch does not exists: $(patch)"; exit 1; fi
