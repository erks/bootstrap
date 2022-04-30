home = ::Dir.home(Bootstrap.owner)
vimrc = File.join(home, '.vimrc')
vundle = File.join(home, '.vim/bundle/Vundle.vim')
exists = File.exists?(vundle)

template vimrc do
  source 'vimrc'
  owner Bootstrap.owner
end

execute "install vundle" do
  command "git clone https://github.com/VundleVim/Vundle.vim.git #{vundle} && vim +PluginInstall +qall"
  user Bootstrap.owner
  live_stream true
  not_if { exists }
end
