# ~/dotfiles

我的个人 dotfiles,使用 [GNU Stow](https://www.gnu.org/software/stow/) 管理软链接。

## 结构

每个顶层目录是一个 Stow **package**,其内部结构镜像 `$HOME` 的相对路径,Stow 据此自动算出软链接位置:

```
~/.dotfiles/
├── nvim/.config/nvim/   # Neovim (LazyVim)
├── zsh/                 # .zshrc, .p10k.zsh, .zshrc.local.example
├── tmux/                # .tmux.conf
├── bash/                # .bashrc
├── git/                 # .gitconfig
├── install.sh           # 一键安装(stow + tpm)
├── doctor.sh            # 配置健康检查
└── .gitignore
```

## 安装(新机器一键恢复)

```bash
# 1. 前置依赖
sudo apt-get install -y stow      # Debian/Ubuntu/WSL
# brew install stow               # macOS / Linuxbrew

# 2. 克隆并安装
git clone https://github.com/HYPERVAPOR/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install.sh
```

`install.sh` 会用 Stow 建立所有软链接,并初始化 tmux 插件管理器 (tpm)。

## 日常用法(Stow)

```bash
cd ~/.dotfiles
stow zsh                       # 建立/更新 zsh 的链接
stow -D zsh                    # 移除 zsh 的链接
stow nvim zsh tmux bash git    # 重新链接全部
```

## 健康检查

```bash
~/.dotfiles/doctor.sh
```

## 私密配置

敏感信息(如 token、密钥)放在 `~/.zshrc.local`,该文件被 `.gitignore` 忽略,绝不入库。
首次安装会从 `zsh/.zshrc.local.example` 复制一份模板。
