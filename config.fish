# gets the name of the current script
set -l current_file (status filename)

# source all *.fish files except this one
for file in ~/.config/fish/*.fish
  if test "$file" != "$current_file"
    source $file
  end
end
