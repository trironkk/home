init:
	sudo apt install -y \
	    autoconf \
	    automake \
	    gcc \
	    git \
	    htop \
	    jq \
	    libevent-dev \
	    libltdl7 \
	    liblzma-dev \
	    libncurses-dev \
	    libpcre3-dev \
	    make \
	    pkg-config \
	    pkg-config \
	    stow \
	    tar \
	    tmux \
	    vim \
	    wget \
	    zlib1g-dev \
	    zsh

default-shell:
	sudo chsh -s "$(shell which zsh)" "${USER}"

# Convenience hack to upgrade tmux for default gce vms, which defaulted
# to 2.3 as of 2019-09-23.
TMUX_VERSION=2.7
tmux:
	cd "$(mktemp -d)" \
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

install:
	cd stows/ && stow --target "${HOME}" *

fzf:
	"${HOME}/.fzf/install" --bin

uninstall:
	cd stows/ && stow --delete --target "${HOME}" *

clean:
	rm -rf vim/.vim
