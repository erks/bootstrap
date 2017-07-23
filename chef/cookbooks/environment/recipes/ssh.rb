home = ENV['HOME']

directory "#{home}/.ssh" do
    recursive true
    owner ENV["USER"]
end

cookbook_file "#{home}/.ssh/config" do
    source "ssh_config"
    mode "600"
    owner ENV["USER"]
    action :create_if_missing
end

key_path = "#{home}/Google Drive/keys/touch@ungboriboonpisal.com.nopass"

file key_path do
    mode "600"
end

execute "add key to keychain" do
    command "ssh-add -K '#{key_path}'"
    not_if "ssh-add -l | grep '#{key_path}'"
end
