include_recipe 'bootstrap::base'

home = ::Dir.home(Bootstrap.owner)
profile_path = File.join(home, ".profile")
bashrc_path = File.join(home, ".bashrc")
zshrc_path = File.join(home, ".zshrc")

source_path = node['bootstrap']['paths']['source']
output_path = node['bootstrap']['paths']['output']

%w(profile.sh aliases.sh functions.sh brew.sh bash.sh zsh.sh gitconfig tmux.conf vimrc).each do |file|
  template File.join(output_path, file) do
    source file
    owner Bootstrap.owner
    variables :bootstrap_dir => source_path,
              :name => node['bootstrap']['name'],
              :email => node['bootstrap']['email']
  end
end

file profile_path do
  owner Bootstrap.owner
end

ruby_block "update .profile" do
  block do
    fe = Chef::Util::FileEdit.new(profile_path)
    fe.insert_line_if_no_match(/profile\.sh/,
                               "source #{File.join(output_path, 'profile.sh')}")
    fe.write_file
  end
end

ruby_block "update shell rc file" do
  block do
    fe = Chef::Util::FileEdit.new(ENV['SHELL'].include?('zsh') ? zshrc_path : bashrc_path)
    fe.insert_line_if_no_match(/\.profile/,
                               "[[ -f \"$HOME/.profile\" ]] && source \"$HOME/.profile\"")
    fe.write_file
  end
end
