# get the directory the script is being run from
export DOTDIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source $DOTDIR/shell/exports.sh

ln -s $DOTDIR/git/gitconfig $HOME/.gitconfig

[ ! -d $XDG_CONFIG_HOME ] && mkdir $XDG_CONFIG_HOME
