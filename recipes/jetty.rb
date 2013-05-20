#
# Cookbook Name:: jetty
# Recipe:: jetty
#
#

# include epel on redhat/centos 5 and below in order to get the memcached packages
if node['platform_family'] == "rhel" and node['platform_version'].to_i < 6
 include_recipe "yum::epel"
end

case node['platform_family']
when "debian"
  package "jsvc"
  if node['platform'] == "ubuntu" && node['platform_version'].to_f >= 11.10
    package "openjdk-7-jdk"
  else
    package "openjdk-6-jdk"
  end
when "rhel","fedora"
  package "java-1.7.0-openjdk"
end


version = node['jetty']['source']['version']
source_url = node['jetty']['source']['url']
tarball_name = "jetty-distribution-#{version}.tar.gz"


directory node['jetty']['home'] do
  owner node['jetty']['user']
  group node['jetty']['group']
  mode  00755
  action :create
  recursive true
end

remote_file "#{Chef::Config[:file_cache_path]}/#{tarball_name}" do
  source source_url
  checksum node['jetty']['source']['checksum']
  mode "0644"
end

execute "uncompress" do
  user node['jetty']['user']
  cwd Chef::Config[:file_cache_path]
  command "tar xpf #{tarball_name}"
end

bash "install" do
  user node['jetty']['user']
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    rm -rf #{node['jetty']['home']}
    mv #{tarball_name.gsub('.tar.gz', '')} #{node['jetty']['home']}
  EOH
end

file "#{node['jetty']['home']}/start.d/900-demo.ini" do
  action :delete
end
file "#{node['jetty']['home']}/etc/jetty-demo.xml" do
  action :delete
end
directory "#{node['jetty']['home']}/contexts/" do
  action :delete
  recursive true
end
directory "#{node['jetty']['home']}/webapps.demo/" do
  action :delete
  recursive true
end
directory "#{node['jetty']['home']}/webapps/" do
  action :delete
  recursive true
end

directory "#{node['jetty']['home']}/webapps/" do
  owner node['jetty']['user']
  group node['jetty']['group']
  mode  00755
  action :create
  recursive true
end

directory "#{node['jetty']['home']}/contexts/" do
  owner node['jetty']['user']
  group node['jetty']['group']
  mode  00755
  action :create
  recursive true
end

template "#{node['jetty']['home']}/contexts/solr.xml" do
  source "jetty_solr.xml.erb"
  owner node['jetty']['user']
  group node['jetty']['group']
  mode "0644"
end

template "/etc/default/jetty" do
  source "jettyrc.erb"
  owner "root"
  group "root"
  mode "0644"
  only_if do ::File.directory?("/etc/default") end
end

template "#{node['jetty']['home']}/resources/log4j.properties" do
  source "log4j.properties"
  owner node['jetty']['user']
  group node['jetty']['group']
  mode "0644"
end

bash "copy solr.war and libs" do
  user node['jetty']['user']
  cwd node['jetty']['home']
  code <<-EOH
    cp #{node['solr']['home']}/solr.war ./webapps/solr.war
    cp #{node['solr']['home']}/example/lib/ext/* ./lib/ext/
  EOH
end
