execute "perocona-release install" do
  command "yum install -y #{node['sysbench']['url_path']}"
  not_if "rpm -qa | grep -q percona-release"
end

package "sysbench" do
  action :install
  options "--enablerepo=percona"
end
