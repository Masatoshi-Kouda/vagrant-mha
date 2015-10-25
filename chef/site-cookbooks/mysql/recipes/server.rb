package "perl-Data-Dumper" do
  action :install
end

execute "MySQL-shared-compat install" do
    command "yum install -y #{node['mysql']['url_path']}/#{node['mysql']['shared_compat']}"
    not_if "rpm -qa | grep -q MySQL-shared-compat"
end

execute "MySQL-server install" do
    command "yum install -y #{node['mysql']['url_path']}/#{node['mysql']['server']}"
    not_if "rpm -qa | grep -q MySQL-server"
end

execute "MySQL-devel install" do
    command "yum install -y #{node['mysql']['url_path']}/#{node['mysql']['devel']}"
    not_if "rpm -qa | grep -q MySQL-devel"
end

execute "MySQL-shared install" do
    command "yum install -y #{node['mysql']['url_path']}/#{node['mysql']['shared']}"
    not_if "rpm -qa | grep -q MySQL-shared"
end
