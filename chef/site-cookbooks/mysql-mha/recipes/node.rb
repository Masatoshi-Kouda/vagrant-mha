%w{
perl-DBD-MySQL
}.each do |pkg|
  package pkg do
    action :install
  end
end

execute "mha4mysql-node install" do
  command "rpm -ivh #{node['mha']['node']['url_path']}"
  not_if "rpm -qa | grep -q mha4mysql-node"
end
