<div style="font-family: JetBrainsMono Nerd Font">

# Setup neovim for development

## Table of Content

<!-- vim-markdown-toc Redcarpet -->

* [1. Install neovim](#1-install-neovim)
* [2. Install some needed packages (I think because I change my config eventually)](#2-install-some-needed-packages-i-think-because-i-change-my-config-eventually)
* [3. Install my config](#3-install-my-config)
* [4. Install plugins](#4-install-plugins)
* [5. Notice:](#5-notice)

<!-- vim-markdown-toc -->

### 1. Install neovim

- Go to the [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)'s page and follow the instruction to download neovim (Stable or Nightly version)

### 2. Install some needed packages (I think because I change my config eventually)

- Install Python3-pip

```bash
sudo apt install python3-pip
```

- Install `pynvim` and `pyx` 

```bash
pip install pyx pynvim -y
```

- Install `nvm`

```bash
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 

```

- Install `nodejs` (18 is the lastest stable version at the time I'm writing this, replace it with yours)

```bash
nvm install 18
```



### 3. Install my config

- Download the `Github config`

```bash
git clone https://github.com/ncudnos/nvim-setup-with-coc2.git
```

- Move the `config folder` into `.config` folder

```bash
mv nvim-setup-with-coc/nvim ~/.config
```

- Install vim-plug

```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

- Open `neovim` by typing 

```bash
nvim
```

### 4. Install plugins

- In `Nvim` screen, type:

```vim
:PlugInstall
```

### 5. Notice:

- My Markdown Preview plugin needs an extra step, in Nvim screen, type:

```bash
:call mkdp#util#install()
```

</div>

### 6. If you prefer `lsp`

- I have another config using `LSP` for my Neovim. You can go to the [LINK](https://github.com/ncudnos/nvim-setup-with-lsp)
