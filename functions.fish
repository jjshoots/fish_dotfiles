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

# fzf + cd + directories only
function ccd -d "Opens up fzf for directories only then navigates to it."
  # check if we have a directory, otherwise just use the current one
  set -l base_dir "."
  if set -q argv[1]
    set base_dir $argv[1]
  end

  # update the find command and add all the exclusion patterns
  set -l find_command "find $base_dir -maxdepth 3 -type d"
  for pattern in $exclude_patterns
    set find_command "$find_command -not \( -path '$pattern' \)"
  end

  # Execute the find command, pipe to fzf, and change to the selected directory
  set -l target $(eval $find_command | fzf)

  # target here is an ARRAY, so we use array-esque checks
  if set -q target[1]
    cd $target
  end
  echo $target
end

# fzf + tmux new sessions
function tn -d "Opens FZF to select a directory, then opens a tmux session in that directory."
  # bootstrap off ccd command to find directories
  if test -z (ccd $argv)
    return
  end
  set -l session_name (basename (pwd))

  # replace . with _
  set -l session_name (echo $session_name | sed 's/\./_/g')

  # if no tmux session, create it in the background
  if not tmux has-session -t $session_name >/dev/null 2>&1
    tmux new-session -d -s $session_name
  end

  # if we're already in a tmux session, switch to the new one, otherwise, attach
  if set -q TMUX
    tmux switch-client -t $session_name
  else
    tmux attach -t $session_name
  end
end

# fzf + tmux existing sessions
function ts -d "Pipes `tmux list-sessions` into fzf, then attaches to the chosen one."
  # if no sessions, just exit
  if not tmux list-sessions > /dev/null 2>&1
    echo "No tmux sessions available at this moment."
    return
  end

  # we have sessions available here, pipe into fzf
  set -l session_name (tmux list-sessions | sed -E 's/:.*$//' | fzf)

  # if no session selected, just exit
  if test -z "$session_name"
    return
  end

  # if we're already in a tmux session, just switch to the selected one, otherwise, attach
  if set -q TMUX
    tmux switch-client -t $session_name
  else
    tmux attach -t $session_name
  end
end
