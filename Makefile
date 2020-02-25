NAME := powerline-v
SRCS = $(wildcard *.v)

all: $(SRCS)
	v -o bin/$(NAME) .

run:
	v run . -o $@

build:
	v build .

./bin/$(NAME): $(SRCS)
	$(MAKE)

install: ./bin/$(NAME)
	sudo  ln -sf $$(pwd)/bin/$(NAME) /usr/local/bin/$(NAME)

.PHONY: clean
clean:
	rm -rf bin
