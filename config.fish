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

# disable pip outside of venv
set -gx PIP_REQUIRE_VIRTUALENV true

# python venv sourcing
function sv -d "Sources a venv within the current directory."
  # check if we have another venv sourced, if we do then deactivate
  if set -q virtual_env
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
  deactivate
end

# python runtime paths
if test -e $HOME/.local/bin
  set -gx PATH $PATH $HOME/.local/bin
end
# rust paths
if test -e $HOME/.cargo/bin
  set -gx PATH $PATH $HOME/.cargo/bin
end
# jekyll gems
if test -e $HOME/System/gems
  set -gx GEM_HOME $HOME/System/gems
  set -gx PATH $PATH $HOME/System/gems/bin
end
