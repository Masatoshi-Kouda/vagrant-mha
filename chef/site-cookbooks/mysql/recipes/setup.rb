template "/etc/rc.d/init.d/mysql" do
  source "mysql_init_script"
  mode 0755
  owner "root"
  group "root"
end

service "mysql" do
  action [ :enable, :start ]
end

bash 'mysql_secure_install' do
  code <<-EOH
    export Initial_PW=`head -n 1 /root/.mysql_secret |awk '{print $(NF - 0)}'`
    mysql -u root -p${Initial_PW} --connect-expired-password -e "SET PASSWORD FOR root@localhost=PASSWORD('#{node['mysql']['user']['root']}');"
    mysql -u root -p#{node['mysql']['user']['root']} -e "SET PASSWORD FOR root@'127.0.0.1'=PASSWORD('#{node['mysql']['user']['root']}');"
    mysql -u root -p#{node['mysql']['user']['root']} -e "DELETE FROM mysql.user WHERE User='';"
    mysql -u root -p#{node['mysql']['user']['root']} -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');"
    mysql -u root -p#{node['mysql']['user']['root']} -e "DROP DATABASE test;"
    mysql -u root -p#{node['mysql']['user']['root']} -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    mysql -u root -p#{node['mysql']['user']['root']} -e "FLUSH PRIVILEGES;"
  EOH
  action :run
  not_if "mysql -u root -p#{node['mysql']['user']['root']} -e 'show databases;'"
end

bash 'rpl_semi_sync_master install' do
  code <<-EOH
    mysql -u root -p#{node['mysql']['user']['root']} -e "INSTALL PLUGIN rpl_semi_sync_master SONAME 'semisync_master.so';"
  EOH
  action :run
  not_if "mysql -u root -p#{node['mysql']['user']['root']} -e 'SHOW PLUGINS;' | grep rpl_semi_sync_master"
end

bash 'rpl_semi_sync_slave install' do
  code <<-EOH
    mysql -u root -p#{node['mysql']['user']['root']} -e "INSTALL PLUGIN rpl_semi_sync_slave SONAME 'semisync_slave.so';"
  EOH
  action :run
  not_if "mysql -u root -p#{node['mysql']['user']['root']} -e 'SHOW PLUGINS;' | grep rpl_semi_sync_slave"
end

bash 'create replicaton user' do
  code <<-EOH
    mysql -u root -p#{node['mysql']['user']['root']} -e "GRANT REPLICATION SLAVE ON *.* TO 'replication'@'10.%.%.%' IDENTIFIED BY '#{node['mysql']['user']['replication']}';"
  EOH
  action :run
  not_if "mysql -u root -p#{node['mysql']['user']['root']} -e 'SELECT User,Host FROM mysql.user;' | grep replication"
end

bash 'create mha user' do
  code <<-EOH
    mysql -u root -p#{node['mysql']['user']['root']} -e "GRANT ALL PRIVILEGES ON *.* TO 'mha'@'10.%.%.%' IDENTIFIED BY '#{node['mysql']['user']['mha']}';"
  EOH
  action :run
  not_if "mysql -u root -p#{node['mysql']['user']['root']} -e 'SELECT User,Host FROM mysql.user;' | grep mha"
end
