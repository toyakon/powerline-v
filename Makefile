NAME := powerline-v

bin/$(NAME): main.v
	v run . -o $@

build:
	v build .

install:
	cp ./bin/$(NAME) ~/.local/bin/$(NAME)

.PHONY: clean
clean:
	rm -rf bin
