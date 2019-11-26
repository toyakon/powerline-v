# powerline-v
なんちゃってPowerline

いまのとこBashのみ

# Install
1. vlangをインストール ([vlang/v](https://github.com/vlang/v))
2. cloneしてcdしてmake

```
git clone https://github.com/toyakon/powerline-v
cd powerline-v
make
make install
```

3. .bashrcに追記
```
function _update_ps1() {
    PS1="$(powerline-v -err $?)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND=_update_ps1
fi
```

# Option
- cwd_depth int
    - cwdで表示する数。0でフルパスを表示。初期値0
- short_cwd
    - 指定すると現在位置以外頭文字だけで表示する

