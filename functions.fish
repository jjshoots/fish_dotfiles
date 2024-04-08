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

# find command for fzf
function limit_find -d "Performs a find with depth 3 and excludes various hidden files."
  # define the find command
  set -l find_command "find . -maxdepth 3 -type d"

  # update the find command and exclusion patterns
  set -l exclude_patterns \
    '*/.*' \
    '*/.git/*' \
    '*/venv/*' \
    '*/.venv/*' \
    '*/venv'
  for pattern in $exclude_patterns
    set find_command "$find_command -not \( -path '$pattern' \)"
  end

  # evaluate the find command
  eval "$find_command"
end

# fzf + cd + directories only
function ccd -d "Opens up fzf for directories only then navigates to the chosen directory"
  # store the current directory in case of cancellation
  set -l start_dir (pwd)

  # if we have a directory, cd into it
  if set -q argv[1]
    # if the directory is invalid just return
    if not test -d $argv[1]
      echo "This is not a valid directory to ccd into."
      return
    end
    # perform the find from this directory, so cd to it
    cd $argv[1]
  end

  # execute the find command, pipe to fzf, set the target dir
  set -l target (limit_find | fzf)

  # target here is an ARRAY, so we use array-esque checks
  if set -q target[1]
    cd $target
    echo $target
  else
    cd $start_dir
    return
  end
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
