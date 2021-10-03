module Bootstrap
    extend self
  
    def owner
      owner = owner_attr || sudo_user || current_user
      if owner == 'root'
        raise Chef::Exceptions::User,
              "Homebrew owner is 'root' which is not supported. " \
             "To set an explicit owner, please set node['homebrew']['owner']."
      end
      owner
    end
  
    private
  
    def owner_attr
      Chef.node['bootstrap']['owner']
    end
  
    def sudo_user
      ENV['SUDO_USER']
    end
  
    def current_user
      ENV['USER']
    end
  end unless defined?(Bootstrap)
