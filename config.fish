set -l current_file (status filename)  # Gets the name of the current script

for file in ~/.config/fish/*.fish
  if test "$file" != "$current_file"
    source $file
  end
end
