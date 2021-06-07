all: init stow install-fzf install-ag install-tmux install-vim

init:
	sudo apt update \
	&& sudo apt install -y \
	    autoconf automake gcc git htop jq libevent-dev libltdl7 liblzma-dev libncurses-dev libpcre3-dev make pkg-config pkg-config stow tar tmux vim wget zlib1g-dev zsh fd-find

stow:
	cd stows/ && stow --target "${HOME}" *

install-vim:
	vim +PlugInstall +qall

install-fzf:
	"${HOME}/.fzf/install" --bin

AG_VERSION=2.2.0
install-ag:
	cd "$(shell mktemp -d)" \
	&& pwd \
	&& sudo apt-get -y remove silversearcher-ag \
	&& sudo apt-get -y install wget tar libevent-dev libncurses-dev \
	&& wget "https://geoff.greer.fm/ag/releases/the_silver_searcher-${AG_VERSION}.tar.gz" \
	&& tar -xvf "the_silver_searcher-${AG_VERSION}.tar.gz" \
	&& cd "the_silver_searcher-${AG_VERSION}" \
	&& ./configure \
	&& make \
	&& sudo make install

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
