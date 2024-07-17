all: init stow install-fzf install-neovim

init:
	sudo apt update \
	&& sudo apt install -y \
	        autoconf \
	        automake \
	        autorandr \
	        bat \
	        cmake \
	        curl \
	        doxygen \
	        fd-find \
	        g++ \
	        gcc \
	        gettext \
	        git \
	        htop \
	        fzf \
	        jq \
	        libevent-dev \
	        libltdl7 \
	        liblzma-dev \
	        libncurses-dev \
	        libpcre3-dev \
	        libtool \
	        libtool-bin \
	        make \
	        ninja-build \
	        nodejs \
	        pkg-config \
	        silversearcher-ag \
	        stow \
	        tar \
	        tmux \
	        unzip \
	        vim \
	        wget \
	        zlib1g-dev \
	        zsh \
	        ripgrep

stow:
	mkdir -p "${HOME}/.tmux/plugins"
	cd stows/ && stow --target "${HOME}" *

install-neovim:
	NEOVIM_VERSION=v0.10.0
	git clone --depth 1 --branch "v0.10.0" "https://github.com/neovim/neovim" "${HOME}/local/github.com/neovim/neovim"
	cd "${HOME}/local/github.com/neovim/neovim" && make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install

default-shell:
	sudo chsh -s "$(shell which zsh)" "${USER}"

unstow:
	cd stows/ && stow --delete --target "${HOME}" *

clean:
	rm -rf vim/.vim
