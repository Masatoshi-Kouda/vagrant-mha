directory "/root/.ssh" do
  mode 0700
  owner "root"
  group "root"
  action :create
end

template "/root/.ssh/id_rsa" do
  source "root/id_rsa"
  mode 0600
  owner "root"
  group "root"
end

template "/root/.ssh/id_rsa.pub" do
  source "root/id_rsa.pub"
  mode 0644
  owner "root"
  group "root"
end

template "/root/.ssh/authorized_keys" do
  source "root/authorized_keys"
  mode 0600
  owner "root"
  group "root"
end
