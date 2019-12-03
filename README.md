# powerline-v
nanchatte powerline.
bash powerline for vlang.

# Install
1. install vlang ([vlang/v](https://github.com/vlang/v))
2. install vargparse ([toyakon/argparse-v](https://github.com/toyakon/argparse-v))
3. clone this repository.

```
git clone https://github.com/toyakon/powerline-v
cd powerline-v
make install
```

4. Added to .bashrc
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
    - view cwd depth int 
- short_cwd
    - It will be displayed in initials except the current directory.
- ppid
    - Pass the PPID of the bash being executed. This is necessary to use the job segment.

```
PS1="$(powerline-v -ppid $$ -err $? -cwd_depth 1 -short_cwd)"

```
