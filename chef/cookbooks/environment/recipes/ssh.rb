home = ENV['HOME']
key_path = "#{home}/Library/Mobile Documents/com~apple~CloudDocs/keys/touch@ungboriboonpisal.com.nopass"

directory "#{home}/.ssh" do
    recursive true
    owner ENV["USER"]
end

template "#{home}/.ssh/config" do
    source "ssh_config.erb"
    mode "600"
    owner ENV["USER"]
    variables key_path: key_path
end

file key_path do
    mode "600"
end

execute "add key to keychain" do
    command "ssh-add -K '#{key_path}'"
    not_if "ssh-add -l | grep '#{key_path}'"
end
