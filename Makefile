.PHONY: setup build-all help

setup: ## build or rebuild the docker image
	./utils/setup.sh

build-all: ## build mindroid (minimal android), kernels, and images
	./utils/run_in_docker.sh "build_all.sh"

build-android: ## build mindroid (minimal android)
	./utils/run_in_docker.sh "build_android.sh"

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
