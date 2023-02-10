# fish settings
set -g fish_term24bit 0
set -g -x fish_greeting ''

# STOP USING RM
alias rm='echo "This is not the command you are looking for."; false'
alias tp=trash-put

# change ls to exa
alias ls=exa\ --icons

# tmux
alias ta=tmux\ attach\ -t
alias tk=tmux\ kill-session\ -t

# python venv sourcing
alias sv=source\ venv/bin/activate.fish
alias dv=deactivate

# check for venv to source when nvim
function vvim -d "Call neovim but also check if venv exists to source."
  # if a venv exists
  if test -e ./venv/bin/activate.fish
    # check if we have another venv sourced, if we do then deactivate
    if set -q VIRTUAL_ENV
      deactivate
    end

    # source the current venv, nvim, cleanup
    source venv/bin/activate.fish
    nvim $argv
    deactivate
  else
    nvim $argv
  end
end

# ensure venv activated before using pip
function pip3 -w "pip3"
  # compare the runtime to the expected one
  if [ (which python3) != "/usr/bin/python3" ]
    python3 -m pip $argv
  else
    echo "You are calling pip3 without using a virtual environment. This is not permitted."
  end
end

# ensure override pip
function ppip3
    python3 -m pip $argv
end
