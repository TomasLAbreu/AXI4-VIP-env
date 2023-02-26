all: run

.PHONY: all run comp sim update clean

run: ## Compile and simulate project
	@cd scripts; ./axi_vip.sh -run

comp: ## Compile project
	@cd scripts; ./axi_vip.sh -comp

sim: ## Simulate project
	@cd scripts; ./axi_vip.sh -sim

update: ## Update constants, vlog.prj and protoinst files
	@cd scripts; ./update.sh

clean: ## Clean working directory
	@cd scripts; ./axi_vip.sh -clean

help: ## Generate list of targets with descriptions
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-15s $(RESET)%s\n", $$1, $$2}'