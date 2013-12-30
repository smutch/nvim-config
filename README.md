vim-setup
=========

My vim setup.  A relatively recent version of vim with python support is required.


Usage
-----

1. Clone this repo into ~/.vim
2. Clone the Vundle plugin manager:
``` sh
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
```
3. Soft-link vimrc to ~/.vimrc:
``` vimscript
    cd ~
    ln -s .vim/vimrc .vimrc
```
4. Lastly run the following command in the terminal:
``` sh
    vim +BundleInstall +qall
```
**Note:** You _will_ get errors when you run this command.  Don't worry about this though - just ignore them.  You only need to be concerned if you still get errors the next time you run vim.

Now your good to go!...

