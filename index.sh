# From https://stackoverflow.com/a/246128
THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
current_dir=`dirname "${THIS}"`


source "$current_dir/config_access.sh"
source "$current_dir/git.sh"
source "$current_dir/navigation.sh"
source "$current_dir/program_aliases.sh"
source "$current_dir/terminal_customization.sh"