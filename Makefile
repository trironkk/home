all: init stow install-fzf install-tmux install-vim

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
	cd stows/ && stow --target "${HOME}" *

install-neovim:
	mkdir "${HOME}/local/github.com/neovim/neovim"
	git clone "https://github.com/neovim/neovim" "${HOME}/local/github.com/neovim/neovim"
	cd "${HOME}/local/github.com/neovim/neovim"
	make CMAKE_BUILD_TYPE=RelWithDebInfo
	sudo make install
	git clone --depth 1 "https://github.com/wbthomason/packer.nvim" "${HOME}/local/share/nvim/site/pack/packer/start/packer.nvim"
	# TODO: Trigger PackerSync.

install-vim:
	vim +PlugInstall +qall

install-fzf:
	"${HOME}/.fzf/install" --bin

default-shell:
	sudo chsh -s "$(shell which zsh)" "${USER}"

configure-guake:
	gconftool-2 --load guake/apps-guake.xml
	gconftool-2 --load guake/schemas-apps-guake.xml

# Convenience hack to upgrade tmux for default gce vms, which defaulted
# to 2.3 as of 2019-09-23.
TMUX_VERSION=2.9a
install-tmux:
	cd "$(shell mktemp -d)" \
	&& sudo apt-get -y remove tmux \
	&& sudo apt-get -y install wget tar libevent-dev libncurses-dev \
	&& wget https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz \
	&& tar xf tmux-${TMUX_VERSION}.tar.gz \
	&& rm -f tmux-${TMUX_VERSION}.tar.gz \
	&& cd tmux-${TMUX_VERSION} \
	&& ./configure \
	&& make \
	&& sudo make install \
	&& cd - \
	&& sudo rm -rf /usr/local/src/tmux-* \
	&& sudo mv tmux-${TMUX_VERSION} /usr/local/src

unstow:
	cd stows/ && stow --delete --target "${HOME}" *

clean:
	rm -rf vim/.vim
