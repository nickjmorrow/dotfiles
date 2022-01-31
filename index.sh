# From https://stackoverflow.com/a/246128
THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
current_dir=`dirname "${THIS}"`

# current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# current_dir+="/Projects/dotfiles"
# current_dir="/Users/nicholasmorrow/Projects/dotfiles"

source "$current_dir/config_access.sh"
source "$current_dir/git.sh"
source "$current_dir/general_navigation.sh"
source "$current_dir/program_aliases.sh"
source "$current_dir/zsh_config.sh"
# Resolve issue with script before uncommenting. See comment in file.
# source "$current_dir/install_oh_my_zsh.sh"
