#!/bin/zsh
# Confirms every installed app in apply-icons.sh has its custom icon. Exit 0 = all set.
exec "${0:A:h}/apply-icons.sh" --check
