template "/etc/my.cnf" do
  source "my.cnf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, 'service[mysql]'
  variables({
    :port => node['mysql']['conf']['port'],
    :innodb_buffer_pool_size => node['mysql']['conf']['innodb_buffer_pool_size']
  })
end

template "/etc/logrotate.d/mysql" do
  source "mysql.logrotate.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :root_password => node['mysql']['user']['root']
  })
end
