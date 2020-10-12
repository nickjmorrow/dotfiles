# From https://stackoverflow.com/a/246128
THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
current_dir=`dirname "${THIS}"`

# current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_dir="/Users/nicholas.morrow/Projects/dotfiles"


source "$current_dir/config_access.sh"
source "$current_dir/git.sh"
source "$current_dir/general_navigation.sh"
source "$current_dir/program_aliases.sh"
# source "$current_dir/terminal_customization.sh"
source "$current_dir/work_index.sh"
