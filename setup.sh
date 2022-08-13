# get the directory the script is being run from
export DOTDIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

ln -s $DOTDIR/git/gitconfig $HOME/.gitconfig
