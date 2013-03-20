cookbook_file "/usr/libexec/ssh-askpass" do
    mode "755"
    owner "root"
    group "wheel"
    action :create_if_missing
end

home = ENV['HOME']
key_path = "#{home}/Dropbox/keys/touch@ungboriboonpisal.com"

file key_path do
    mode "600"
end

execute "add key to keychain" do
    command "ssh-add -K #{key_path}"
    not_if "ssh-add -l | grep #{key_path}"
end

