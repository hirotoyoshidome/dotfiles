## Bash

`ubuntu/.bashrc` は 1 ファイル運用です。以下の optional な依存は、未導入でも `.bashrc` 自体はエラーにならない想定です。

* `omohi` bash completion
* SDKMAN
* NVM
* Java 21 (`/usr/lib/jvm/java-21-openjdk-amd64`)
* Zig (`/opt/zig`)

インストール先が異なる場合は、`.bashrc` 内の該当パスを合わせてください。

## Vim

共通設定:

```sh
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
cd ~/.vim/bundle
git clone https://github.com/scrooloose/syntastic.git
git clone https://github.com/preservim/nerdtree.git
git clone https://github.com/vim-airline/vim-airline.git
```

* `nerdtree` - ディレクトリ見やすく
* `syntastic` - 構文エラーチェック
* `vim-airline` - 表示をかっこよく

### C/C++用

* https://github.com/justmao945/vim-clang

### Nim用の設定(~/.vim/bundleにcloneする)

* choosenim
  * https://nim-lang.org/install_unix.html
* nim.vim
  * https://github.com/zah/nim.vim
