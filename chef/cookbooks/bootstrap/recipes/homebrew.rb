arch = `arch`
homebrew_root_path = arch == 'arm64' ? '/opt/homebrew' : '/usr/local'
homebrew_paths_path = arch == 'arm64' ? '/etc/paths.d/10-brew' : '/etc/paths.d/20-brew'
homebrew_bin_path = File.join(homebrew_root_path, 'bin')
homebrew_exec = File.join(homebrew_bin_path, 'brew')
exists = File.exists?(homebrew_exec)

# Install Homebrew: https://brew.sh/
execute "install homebrew" do
  command "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  user Bootstrap.owner
  live_stream true
  not_if { exists }
end

execute homebrew_paths_path do
  command "echo '#{homebrew_bin_path}' | sudo tee '#{homebrew_paths_path}'"
  not_if { File.exists?(homebrew_paths_path) }
end

node['homebrew']['taps'].each do |tap|
  if tap.is_a?(String)
    homebrew_tap tap do
      owner Bootstrap.owner
      homebrew_path homebrew_exec
    end
  elsif tap.is_a?(Hash)
    raise unless tap.key?('tap')
    homebrew_tap tap['tap'] do
      url tap['url'] if tap.key?('url')
      full tap['full'] if tap.key?('full')
      owner Bootstrap.owner
      homebrew_path homebrew_exec
    end
  else
    raise
  end
end

# update after adding taps
execute 'brew update --force' do
  user Bootstrap.owner
  live_stream true
end

node['homebrew']['formulas'].each do |formula|
  if formula.class == Chef::Node::ImmutableMash
    formula_options = formula.fetch(:options, '')
    formula_options += ' --HEAD' if formula.fetch(:head, false)
    homebrew_package formula.fetch(:name) do
      options formula_options.strip
      version formula['version'] if formula.fetch(:version, false)
      homebrew_user Bootstrap.owner
      action :upgrade
    end
  else
    homebrew_package formula do
      homebrew_user Bootstrap.owner
      action :upgrade
    end
  end
end

node['homebrew']['casks'].each do |cask|
  if cask.class == Chef::Node::ImmutableMash
    cask_options = cask.fetch(:options, '')
    cask_options += ' --HEAD' if cask.fetch(:head, false)
    homebrew_cask cask.fetch(:name) do
      options cask_options.strip
      version cask['version'] if cask.fetch(:version, false)
      owner Bootstrap.owner
      homebrew_path homebrew_exec
    end
  else
    homebrew_cask cask do
      owner Bootstrap.owner
      homebrew_path homebrew_exec
    end
  end
end
