package "ntp" do
  action :install
end

service "ntpd" do
  action [ :enable, :start ]
end

template "/etc/ntp.conf" do
  source "ntp.conf"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, 'service[ntpd]'
end

