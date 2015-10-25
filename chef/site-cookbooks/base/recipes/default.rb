# epel,remi,rpmforge install
%w{epel remi rpmforge}.each do |repo|
  execute "#{repo} install" do
    if node['platform_version'].to_i == 6 || node["platform"] == "amazon"
      command "rpm -Uvh #{node["#{repo}"]['centos6']['url_path']}"
    elsif node['platform_version'].to_i == 7 
      command "rpm -Uvh #{node["#{repo}"]['centos7']['url_path']}"
    end
    not_if "rpm -qa | grep -q #{repo}-release"
  end
end

# timezone setup
if node['platform_version'].to_i == 6 || node["platform"] == "amazon"
  cookbook_file "/etc/localtime" do
    source "Tokyo"
    mode 0644
    owner "root"
    group "root"
  end

  template "/etc/sysconfig/clock" do
      source "clock"
      mode 0644
      owner "root"
      group "root"
  end
elsif node['platform_version'].to_i == 7 
  execute "timezone setup" do
    command "timedatectl set-timezone Asia/Tokyo"
    not_if "timedatectl status | grep -q 'Timezone: Asia/Tokyo'"
  end
end

# locale setup
execute "localedef ja_JP.utf8" do
  command "localedef -f UTF-8 -i ja_JP ja_JP.utf8"
  not_if "locale -a | grep -q ja_JP.utf8"
end

if node['platform_version'].to_i == 6 || node["platform"] == "amazon"
  template "/etc/sysconfig/i18n" do
    source "i18n"
    mode 0644
    owner "root"
    group "root"
  end
elsif node['platform_version'].to_i == 7 
  execute "localectl ja_JP.utf8" do
    command "localectl set-locale LANG=ja_JP.utf8"
    not_if "localectl status | grep -q 'System Locale: LANG=ja_JP.utf8'"
  end
end

# base packages install
%w{
vim
tar
git
tree
telnet
sysstat
strace
tcpdump
bind-utils
wget
bash-completion
}.each do |pkg|
  package pkg do
    action :install
  end
end
