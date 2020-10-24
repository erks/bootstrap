home = ENV['HOME']
env_path = File.expand_path(node["paths"]["env"])
bashrc_path = File.join(home, ".bashrc")
bashprofile_path = File.join(home, ".bash_profile")
profile_script_path = File.join(env_path, "profile.sh")

execute "update .bashrc" do
  command "echo \"source #{profile_script_path}\" >> #{bashrc_path}"
  not_if "grep 'profile.sh' #{bashrc_path}"
end

execute "update .bash_profile" do
  command "echo \"[[ -f \\\"\\\$HOME/.bashrc\\\" ]] && source \\\"\\\$HOME/.bashrc\\\"\" >> #{bashprofile_path}"
  not_if "grep '.bashrc' #{bashprofile_path}"
end

