NAME := powerline-v
SRCS = $(wildcard *.v)

all: $(SRCS)
	v -o bin/$(NAME) .

run:
	v run . -o $@

build:
	v build .

install: ./bin/$(NAME)
	cp ./bin/$(NAME) ~/.local/bin/$(NAME)

.PHONY: clean
clean:
	rm -rf bin
