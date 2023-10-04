TINY_NTRIP_DIR := submodules/tiny-ntrip

compile:
	CC=mips-openwrt-linux-musl-gcc LDFLAGS=-static $(MAKE) -C "$(TINY_NTRIP_DIR)"
	@mkdir -p bin
	cp "$(TINY_NTRIP_DIR)/tiny-ntrip" bin
