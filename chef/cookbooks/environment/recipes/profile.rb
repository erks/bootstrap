home = ENV['HOME']
env_path = File.expand_path(node.paths.env)
profile_path = File.join(home, ".profile")
profile_script_path = File.join(env_path, "profile.sh")

execute "update profile" do
    command "echo \"source #{profile_script_path}\" >> #{profile_path}"
    not_if "grep #{profile_script_path} #{profile_path}"
end

