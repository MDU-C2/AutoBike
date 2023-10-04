CC     ?= gcc
CFLAGS ?= -O3

override CFLAGS += -Wall

PROGRAM   := tiny-ntrip
BUILD_DIR := build
SOURCES   := $(shell find . -name '*.c')
OBJECTS   := $(SOURCES:./%.c=$(BUILD_DIR)/%.o)
HEADERS   := $(shell find . -name '*.h')
USAGE     := $(BUILD_DIR)/usage.txt

all: $(PROGRAM)

$(USAGE): README.md
	@mkdir -p $(@D)
	@cat README.md \
		| grep -zPo '(?<=!-- usage-marker -->\n```\n)(.|\n)*?(?=\n```)' \
		| sed -e 's/\x0//g' -e 's/"/\\"/g' -e 's/\(.*\)/"\1\\n"/' > $(USAGE)

$(PROGRAM): $(OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)

$(BUILD_DIR)/%.o: %.c $(USAGE) $(HEADERS)
	@mkdir -p $(@D)
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean
clean:
	rm -f $(PROGRAM)
	rm -Rf $(BUILD_DIR)
	touch $(SOURCES)