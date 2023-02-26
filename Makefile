all: run

.PHONY: all run comp sim update clean

run:
	@cd scripts; ./axi_vip.sh -run

comp:
	@cd scripts; ./axi_vip.sh -comp

sim:
	@cd scripts; ./axi_vip.sh -sim

update:
	@cd scripts; ./update.sh

clean:
	@cd scripts; ./axi_vip.sh -clean