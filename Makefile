.PHONY: setup-env destroy-env create-volume mount-volume unmount-volume delete-volume clone-builder-repo build-docker-image delete-docker-image build-neos help
BRANCH=master

setup-env: create-volume mount-volume clone-builder-repo build-docker-image ## Set up build environment for mac

destroy-env: unmount-volume delete-volume ## Tear down and delete the build environment

create-volume: ## Create a case-sensitive volume for building Android
	./utils.sh create-volume

mount-volume: ## Mount the Android volume
	./utils.sh mount-volume

unmount-volume: ## Unmount the Android volume
	./utils.sh unmount-volume

delete-volume: ## Delete the Android volume
	rm ~/android.dmg.sparseimage

clone-builder-repo: ## Clone this repo in the Android volume
	./utils.sh clone-repo $(BRANCH)

build-docker-image: ## Build the docker image
	docker build -t stecky/eon-neos-builder ./docker

delete-docker-image: ## Delete the docker image
	docker rmi stecky/eon-neos-builder

build-neos: ## Build mindroid (minimal android), kernels, and images
	./utils.sh run-in-docker build_all.sh

help: ## show this help info
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
		IFS=$$'#' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf "%-40s %s\n" $$help_command $$help_info ; \
	done
