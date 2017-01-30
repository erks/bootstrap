directory "/usr/local/libexec" do
    recursive true
    owner ENV["USER"]
end

cookbook_file "/usr/local/libexec/ssh-askpass" do
    source "ssh-askpass.sh"
    mode "755"
    owner ENV["USER"]
    action :create_if_missing
end

home = ENV['HOME']
key_path = "#{home}/Google Drive/keys/touch@ungboriboonpisal.com.nopass"

file key_path do
    mode "600"
end

execute "add key to keychain" do
    command "ssh-add -K #{key_path}"
    not_if "ssh-add -l | grep #{key_path}"
end

directory "#{home}/.ssh" do
    recursive true
    owner ENV["USER"]
end

execute "touch #{home}/.ssh/config"

