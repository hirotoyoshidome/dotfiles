## 共通設定
```
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
cd ~/.vim/bundle
git clone https://github.com/scrooloose/syntastic.git
git clone https://github.com/preservim/nerdtree.git
git clone https://github.com/vim-airline/vim-airline.git
```

* nerdtree - ディレクトリ見やすく
* syntastic - 構文エラーチェック
* vim-airline - 表示をかっこよく

### C/C++用
* https://github.com/justmao945/vim-clang

### Nim用の設定(~/.vim/bundleにcloneする)
* choosenim
  * https://nim-lang.org/install_unix.html
* nim.vim
  * https://github.com/zah/nim.vim

