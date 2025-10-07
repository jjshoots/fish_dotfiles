# macOS empty trash
alias tp "trash"

# change ls to exa
alias ls=eza\ --icons

# vpn enable
alias vpn-up "sudo wg-quick up wg0"
alias vpn-down "sudo wg-quick down wg0"

# caffeinate
alias cap "caffeinate -d python3"

# clean up .DS_Store files
alias clean_ds "find ~ -name '.DS_Store' -type f -delete"
alias clean_ds_all "sudo find / -name '.DS_Store' -type f -delete 2>/dev/null"
