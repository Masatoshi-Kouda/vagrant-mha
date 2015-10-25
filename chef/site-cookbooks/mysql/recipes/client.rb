execute "MySQL-client install" do
    command "yum install -y #{node['mysql']['url_path']}/#{node['mysql']['client']}"
    not_if "rpm -qa | grep -q MySQL-client"
end
