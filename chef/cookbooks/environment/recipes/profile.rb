home = ENV['HOME']
env_path = File.expand_path(node["paths"]["env"])
profile_script_path = File.join(env_path, "profile.sh")
profile_path = File.join(home, ".profile")
zshrc_path = File.join(home, ".zshrc")

execute "update .profile" do
  command "echo \"source #{profile_script_path}\" >> #{profile_path}"
  not_if "grep 'profile.sh' #{profile_path}"
end

execute "update .zshrc" do
  command "echo \"[[ -f \\\"\\\$HOME/.profile\\\" ]] && source \\\"\\\$HOME/.profile\\\"\" >> #{zshrc_path}"
  not_if "grep '.profile' #{zshrc_path}"
  only_if { ENV['SHELL'].include?('zsh') }
end

