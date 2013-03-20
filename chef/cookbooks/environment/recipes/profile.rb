home = ENV['HOME']
random_repo_path = File.expand_path(node.random_repo_path)
profile_path = File.join(home, ".profile")
profile_script_path = File.join(random_repo_path, "env/profile.sh")

execute "update profile" do
    command "echo \"source #{profile_script_path}\" >> #{profile_path}"
    not_if "grep #{profile_script_path} #{profile_path}"
end

