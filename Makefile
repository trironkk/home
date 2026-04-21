PACKAGES := \
	autoconf automake autorandr bat cmake curl fd-find g++ gcc gettext git \
	htop fzf jq libevent-dev libltdl7 liblzma-dev libncurses-dev libpcre3-dev \
	libtool libtool-bin make ninja-build nodejs pkg-config ripgrep stow tar \
	tmux unzip wget zsh

.PHONY: all init stow unstow install-neovim default-shell generate-ssh-key

all: init stow install-neovim

init:
	sudo apt update && sudo apt install -y $(PACKAGES)

stow:
	mkdir -p "$(HOME)/.tmux/plugins"
	mkdir -p "$(HOME)/.config/nvim/lua/trironkk/plugins"
	cd stows && stow --target "$(HOME)" *

unstow:
	cd stows && stow --delete --target "$(HOME)" *

install-neovim:
	git clone --depth 1 --branch nightly \
		https://github.com/neovim/neovim \
		"$(HOME)/local/github.com/neovim/neovim"
	$(MAKE) -C "$(HOME)/local/github.com/neovim/neovim" CMAKE_BUILD_TYPE=RelWithDebInfo
	sudo $(MAKE) -C "$(HOME)/local/github.com/neovim/neovim" install

default-shell:
	sudo chsh -s "$$(which zsh)" "$(USER)"

generate-ssh-key:
	ssh-keygen -t ed25519 -C "trironk@gmail.com"
