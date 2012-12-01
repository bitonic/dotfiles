export EDITOR="emacs -Q -nw -l ~/.emacs.d/basic-bindings.el"

# cabal
export PATH=$PATH:~/.cabal/bin
# LD
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/local/lib
export LD_RUN_PATH=$LD_RUN_PATH:/usr/local/lib
# MATLAB
export PATH=$PATH:~/proprietary/MATLAB/R2011b/bin
# sicstus
export PATH=$PATH:~/installs/sicstus4.2.0/bin
# curry
export PATH=$PATH:~/installs/pakcs/bin
# acroread
export PATH=$PATH:~/proprietary/acroread/Adobe/Reader9/bin

# stupid flag
alias gcc='gcc -Wl,--no-as-needed'

# aliases
alias sml='rlwrap sml'
alias ack='ack-grep'

# ant libraries
export CLASSPATH=$CLASSPATH:/usr/share/java/ant-contrib.jar

# Perl :(
export PERL_LOCAL_LIB_ROOT="/home/bitonic/perl5";
export PERL_MB_OPT="--install_base /home/bitonic/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/bitonic/perl5";
export PERL5LIB="/home/bitonic/perl5/lib/perl5/x86_64-linux-gnu-thread-multi:/home/bitonic/perl5/lib/perl5";
export PATH="/home/bitonic/perl5/bin:$PATH";

# z3
export PATH=$PATH:~/installs/z3/build

autoload -U select-word-style; select-word-style bash

fortune -a -s
