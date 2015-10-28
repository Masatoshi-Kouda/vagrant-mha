%w{
perl-DBD-MySQL
perl-Config-Tiny
perl-Log-Dispatch
perl-Parallel-ForkManager
perl-Time-HiRes
}.each do |pkg|
  package pkg do
    action :install
  end
end

execute "mha4mysql-node install" do
  command "rpm -ivh #{node['mha']['node']['url_path']}"
  not_if "rpm -qa | grep -q mha4mysql-node"
end

execute "mha4mysql-manager install" do
  command "rpm -ivh #{node['mha']['manager']['url_path']}"
  not_if "rpm -qa | grep -q mha4mysql-manager"
end

template "/etc/mha.cnf" do
  source "mha.cnf.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :user => node['mha']['manager']['user'],
    :password => node['mha']['manager']['password'],
    :mysql_port => node['mha']['manager']['mysql_port'],
    :ssh_user => node['mha']['manager']['ssh_user'],
    :ssh_port => node['mha']['manager']['ssh_port'],
    :master_ip_failover_script => node['mha']['manager']['master_ip_failover_script'],
    :node1_hostname => node['mha']['manager']['node1_hostname'],
    :node2_hostname => node['mha']['manager']['node2_hostname'],
    :node3_hostname => node['mha']['manager']['node3_hostname']
  })
end

template "/usr/local/sbin/master_ip_failover" do
  source "master_ip_failover"
  mode 0755
  owner "root"
  group "root"
end
