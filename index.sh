# From https://stackoverflow.com/a/246128

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$current_dir/config_access.sh"
source "$current_dir/git.sh"
source "$current_dir/navigation.sh"
source "$current_dir/program_aliases.sh"
source "$current_dir/terminal_customization.sh"
source "$current_dir/work_functions.sh"