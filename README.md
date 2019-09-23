# Quick Setup:

```shell
sudo apt install -y git make \
&& git clone \
      --depth=1 \
      --recursive \
      --shallow-submodules \
      --jobs=8 \
      "https://github.com/trironkk/Home" "$HOME/local/github.com/trironkk/Home" \
&& make -C "$HOME/local/github.com/trironkk/Home" init \
&& make -C "$HOME/local/github.com/trironkk/Home" tmux \
&& make -C "$HOME/local/github.com/trironkk/Home" install \
&& make -C "$HOME/local/github.com/trironkk/Home" fzf \
&& make -C "$HOME/local/github.com/trironkk/Home" default-shell
```
