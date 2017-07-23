home = ENV['HOME']
key_path = "#{home}/Google Drive/keys/touch@ungboriboonpisal.com.nopass"

directory "#{home}/.ssh" do
    recursive true
    owner ENV["USER"]
end

template "#{home}/.ssh/config" do
    source "ssh_config"
    mode "600"
    owner ENV["USER"]
    variables key_path: key_path
    action :create_if_missing
end

file key_path do
    mode "600"
end

execute "add key to keychain" do
    command "ssh-add -K '#{key_path}'"
    not_if "ssh-add -l | grep '#{key_path}'"
end
