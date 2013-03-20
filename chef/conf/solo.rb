file_cache_path           "/tmp/chef-solo"
data_bag_path             "#{ENV['PWD']}/data_bags"
encrypted_data_bag_secret "/tmp/chef-solo/data_bag_key"
cookbook_path             ["#{ENV['PWD']}/site-cookbooks", "#{ENV['PWD']}/cookbooks"]
role_path                 "#{ENV['PWD']}/roles"
