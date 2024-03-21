# fish settings
set -g fish_term24bit 0
set -g -x fish_greeting ''

# disable pip outside of venv
set -gx PIP_REQUIRE_VIRTUALENV true

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
