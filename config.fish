# gets the name of the current script
set -l current_file (status filename)

# source all *.fish files except this one
for file in ~/.config/fish/*.fish
  if test "$file" != "$current_file"
    source $file
  end
end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
set -gx PATH /opt/homebrew/opt/postgresql@17/bin $PATH
