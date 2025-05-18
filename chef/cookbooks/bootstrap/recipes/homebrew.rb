home = ::Dir.home(Bootstrap.owner)
brewfile_path = File.join(home, '.Brewfile')
homebrew_exec = `command -v brew`.strip

template brewfile_path do
  source 'Brewfile'
  owner Bootstrap.owner
end

execute 'brew update' do
  command "#{homebrew_exec} update --force"
  user Bootstrap.owner
  live_stream true
end

execute 'brew bundle' do
  command "#{homebrew_exec} bundle --global"
  user Bootstrap.owner
  live_stream true
end
