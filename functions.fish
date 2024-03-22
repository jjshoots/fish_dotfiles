# python venv sourcing
function sv -d "Sources a venv within the current directory."
  # check if we have another venv sourced, if we do then deactivate
  if functions -q deactivate
    deactivate
  end
  # source the venv
  if test -e ./venv/bin/activate.fish
    source ./venv/bin/activate.fish
  else if test -e ./.venv/bin/activate.fish
    source ./.venv/bin/activate.fish
  end
end
alias dv=deactivate

# nvim + venv
function vvim -d "Call neovim but also check if venv exists to source."
  sv
  nvim $argv
  if functions -q deactivate
    deactivate
  end
end

# Define the fzf find pattern
set -l exclude_patterns \
  '*/.*' \
  '*/.git/*' \
  '*/venv/*' \
  '*/.venv/*' \
  '*/venv'
set find_command "find . -maxdepth 3 -type d"
for pattern in $exclude_patterns
  set find_command "$find_command -not \( -path '$pattern' \)"
end

# fzf + cd + directories only
function ccd -d "Opens up fzf for directories only then navigates to it"
  # Execute the find command, pipe to fzf, and change to the selected directory
  cd $(eval $find_command | fzf)
end

