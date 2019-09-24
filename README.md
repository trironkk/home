# Quick Setup:

```shell
install_location="$HOME/local/github.com/trironkk/home" \
&& sudo apt install -y git make \
&& git clone \
      --depth=1 \
      --recursive \
      --shallow-submodules \
      "https://github.com/trironkk/home" "$install_location" \
&& make -C "$install_location"
```
