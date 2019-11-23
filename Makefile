NAME := powerline-v
SRCS = $(wildcard *.v)

bin/$(NAME): $(SRCS)
	v run . -o $@

test:
	$(MAKE)

build:
	v build .

install:
	cp ./bin/$(NAME) ~/.local/bin/$(NAME)

.PHONY: clean
clean:
	rm -rf bin
