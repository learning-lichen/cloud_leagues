desc 'Remove unnecessary files from child directories.'

task :clean do 
  sh %{find . -type f -iname "*~" -exec rm -f {} \\;}
end