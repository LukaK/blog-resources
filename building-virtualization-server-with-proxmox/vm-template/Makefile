.PHONY: all pkr_validate pkr_build pkr_build_focal pkr_clean

# Default target executed when no arguments are given to make.
all: help

######################
# PACKER
######################
pkr_validate:
	cd packer/ubuntu-server-focal && packer validate --var-file=../credentials.pkrvars.hcl --var-file=../ubuntu-server-focal.pkrvars.hcl .

pkr_build_focal:
	cd packer/ubuntu-server-focal && packer init .
	cd packer/ubuntu-server-focal && packer build --var-file=../credentials.pkrvars.hcl --var-file=../ubuntu-server-focal.pkrvars.hcl .

pkr_build: pkr_build_focal


pkr_clean:
	echo "Not implemented!"

######################
# HELP
######################

help:
	@echo '===================='
	@echo '-- DOCUMENTATION --'
	@echo 'pkr_validate                 - validate packer files'
	@echo 'pkr_build                    - build packer images'
	@echo 'pkr_build_focal              - build packer ubuntu focal image'
	@echo 'pkr_clean                    - clean proxmox images'
