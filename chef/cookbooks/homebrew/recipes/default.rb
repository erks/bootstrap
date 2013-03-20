execute "install homebrew" do
    command '/usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"'
    not_if { File.exist? '/usr/local/bin/brew' }
end

execute "update homebrew from github" do
    command "/usr/local/bin/brew update || true"
end

package 'bash-completion'

package 'git' do
    options '--with-pcre --with-blk-sha1'
end

