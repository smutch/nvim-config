vim-setup
=========

My vim setup (largely based on http://sontek.net/turning-vim-into-a-modern-python-ide ).  A relatively recent version of vim with both python and ruby support enabled is required.


Usage
-----

Clone this repo into ~/.vim and then use:

    git submodule init
    git submodule update

Next, soft-link vimrc to ~/.vimrc:

    cd ~
    ln -s .vim/vimrc .vimrc

Finally, go into ~/.vim/bundle/command-t/ruby/command-t and issue the command:

    ruby extconf.rb
    make

Now your good to go!...

