# powerline-v
nanchatte powerline.
bash powerline for vlang.

# Install
1. install [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) 

## Compile
1. install vlang ([vlang/v](https://github.com/vlang/v))
2. install vargparse ([toyakon/argparse-v](https://github.com/toyakon/argparse-v))
3. clone this repository.

```
git clone https://github.com/toyakon/powerline-v
cd powerline-v
make install
```

## Download binary
1. Download to [release](https://github.com/toyakon/powerline-v/releases/tag/v1.2) or
```
wget https://github.com/toyakon/powerline-v/releases/download/v1.2/powerline-v
```

2. Change Permission
```
chmod +x powerline-v
```

3. Move to a location written in PATH
```
mv powerline-v ~/.local/bin
```
# Setting
Added to .bashrc
```
function _update_ps1() {
    PS1="$(powerline-v -ppid $$ -err $?)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND=_update_ps1
fi
```
# View Settings
- user
    - user name (Light Blue)
- host
    - host name (yellow)
- ssh 
    - The ssh segment displayed when ssh is connected (Green)
- cwd
    - current working directory is displayed (Gray)
- git
    - git status is displayed. hide if status is 0
    - branch(Dark green) > ahead(Gray) > staged(Green) > not staged(Pink) > untracked(Red)
- job
    - Jub running in current process
- guser
    - git user neme

If not specified, it is equivalent to
```
PS1="$(powerline-v -ppid $$ -err $? user host ssh cwd git job)"
```

## example
```
PS1="$(powerline-v -ppid $$ -err $? ssh guser cwd git job)"
```
```
PS1="$(powerline-v -ppid $$ -err $? user git)"
```

# Option
If used, write before view setting.

- cwd_depth int
    - view cwd depth int 
- short_cwd
    - It will be displayed in initials except the current directory.
- ppid
    - Pass the PPID of the bash being executed. This is necessary to use the job segment.

```
PS1="$(powerline-v -ppid $$ -err $? -cwd_depth 1 -short_cwd)"

```
