current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

dotfiles_dir=${rider_dir:-$current_dir}

source "$dotfiles_dir/config_access.sh"
source "$dotfiles_dir/git.sh"
source "$dotfiles_dir/general_navigation.sh"
source "$dotfiles_dir/program_aliases.sh"
source "$dotfiles_dir/terminal_customization.sh"
source "$dotfiles_dir/work_navigation.sh"